import os
import shutil
import subprocess
from flask import Flask, jsonify, request, send_file

app = Flask(__name__)

def encontrar_swipl():
    """Detecta automaticamente o executável do SWI-Prolog no sistema."""
    # 1. Tenta encontrar no PATH do sistema
    caminho = shutil.which("swipl")
    if caminho:
        return caminho

    # 2. Caminhos comuns de instalação no Windows
    candidatos = [
        os.path.expandvars(r"%LOCALAPPDATA%\Programs\swipl\bin\swipl.exe"),
        r"C:\Program Files\swipl\bin\swipl.exe",
        r"C:\Program Files (x86)\swipl\bin\swipl.exe",
        os.path.expanduser(r"~\AppData\Local\Programs\swipl\bin\swipl.exe"),
        r"C:\swipl\bin\swipl.exe",
    ]
    for c in candidatos:
        if os.path.isfile(c):
            return c

    return "swipl"

SWIPL_CMD = encontrar_swipl()

# Se o swipl foi achado em uma pasta específica, adiciona essa pasta ao PATH do processo
pasta_swipl = os.path.dirname(SWIPL_CMD)
if os.path.isdir(pasta_swipl) and pasta_swipl not in os.environ.get("PATH", ""):
    os.environ["PATH"] = pasta_swipl + os.pathsep + os.environ.get("PATH", "")

def executar_prolog(objetivo):
    base_dir = os.path.dirname(os.path.abspath(__file__))
    arquivo_pl = os.path.join(base_dir, "brasileirao.pl")
    
    comando = [SWIPL_CMD, "-q", "-s", arquivo_pl, "-g", objetivo]
    try:
        resultado = subprocess.run(
            comando,
            capture_output=True,
            text=True,
            encoding="utf-8",
            check=True
        )
        return resultado.stdout.strip().split("\n")
    except FileNotFoundError:
        raise RuntimeError(
            f"O executável do SWI-Prolog não foi encontrado no caminho '{SWIPL_CMD}'. "
            "Certifique-se de que o SWI-Prolog está instalado."
        )
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Erro ao executar Prolog: {e.stderr or e.stdout}")

@app.route("/")
def index():
    return send_file("index.html")

@app.route("/api/info")
def api_info():
    """Retorna informações do motor Prolog e ambiente."""
    try:
        res = subprocess.run([SWIPL_CMD, "--version"], capture_output=True, text=True, check=True)
        versao = res.stdout.strip()
        status_ok = True
    except Exception as e:
        versao = str(e)
        status_ok = False

    return jsonify({
        "sucesso": True,
        "prolog_ativo": status_ok,
        "versao": versao,
        "caminho": SWIPL_CMD,
        "rodada": 32,
        "temporada": 2026
    })

@app.route("/api/times")
def api_times():
    tipo = request.args.get("tipo", "todos")
    valor = request.args.get("valor", "")

    if tipo == "todos":
        regra = "todos_times(Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = "todos_times(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "libertadores":
        regra = "libertadores(Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = "libertadores(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "sulamericana":
        regra = "sulamericana(Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = "sulamericana(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "rebaixamento":
        regra = "rebaixamento(Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = "rebaixamento(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "saldo_positivo":
        regra = "saldo_positivo(Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = "saldo_positivo(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "estado" and valor:
        regra = f"por_estado('{valor}', Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = f"por_estado('{valor}', Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    elif tipo == "regiao" and valor:
        regra = f"por_regiao('{valor}', Pos, Nome, UF, Reg, Pts, J, V, E, D, GP, GC, SG)"
        query_str = f"por_regiao('{valor}', Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG)."
    else:
        return jsonify({"sucesso": False, "erro": "Filtro inválido"}), 400

    try:
        linhas = executar_prolog(f"exportar_times({regra})")
        times = []
        for linha in linhas:
            if "|" in linha:
                pos, nome, uf, regiao, pts, j, v, e, d, gp, gc, sg = linha.strip().split("|")
                times.append({
                    "pos": int(pos),
                    "nome": nome,
                    "uf": uf,
                    "regiao": regiao,
                    "pontos": int(pts),
                    "jogos": int(j),
                    "vitorias": int(v),
                    "empates": int(e),
                    "derrotas": int(d),
                    "gp": int(gp),
                    "gc": int(gc),
                    "sg": int(sg)
                })
        return jsonify({"sucesso": True, "query_prolog": query_str, "dados": times})
    except Exception as ex:
        return jsonify({"sucesso": False, "erro": str(ex)}), 500

@app.route("/api/jogadores")
def api_jogadores():
    categoria = request.args.get("categoria", "artilheiros")
    if categoria == "artilheiros":
        regra = "todos_artilheiros(Pos, Jogador, Clube, Gols)"
        query_str = "todos_artilheiros(Pos, Jogador, Clube, Gols)."
    else:
        regra = "todos_assistentes(Pos, Jogador, Clube, Assistencias)"
        query_str = "todos_assistentes(Pos, Jogador, Clube, Assistencias)."

    try:
        linhas = executar_prolog(f"exportar_jogadores({regra})")
        jogadores = []
        for linha in linhas:
            if "|" in linha:
                pos, jogador, clube, valor = linha.strip().split("|")
                jogadores.append({
                    "pos": int(pos),
                    "jogador": jogador,
                    "clube": clube,
                    "valor": int(valor)
                })
        return jsonify({"sucesso": True, "query_prolog": query_str, "dados": jogadores})
    except Exception as ex:
        return jsonify({"sucesso": False, "erro": str(ex)}), 500

if __name__ == "__main__":
    print(f"Iniciando servidor Brasileirão 2026...")
    print(f"-> SWI-Prolog detectado em: {SWIPL_CMD}")
    print("-> Acesse no navegador: http://127.0.0.1:5000")
    app.run(debug=True, port=5000)
