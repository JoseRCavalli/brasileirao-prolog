# Brasileirao Serie A 2026 - Analise e Inferencia com SWI-Prolog

Aplicacao completa para consulta, filtragem e analise analitica da tabela e estatisticas do Campeonato Brasileiro Serie A 2026 (Rodada 32). O sistema utiliza programacao em logica pura com SWI-Prolog como motor de inferencia, integrado a um backend Python (Flask) e a um dashboard web reativo em JavaScript.

---

## Visao Geral do Projeto

O objetivo do projeto e demonstrar a integracao pratica entre o paradigma de Programacao em Logica e o desenvolvimento de aplicacoes web modernas. Toda a classificacao dos clubes, criterios de vagas para torneios continentais (Libertadores e Sul-Americana), definicao da zona de rebaixamento (Z4), calculo de saldos e estatisticas individuais de artilharia e assistencias sao inferidos dinamicamente por predicados Prolog, sem consultas a bancos de dados SQL/NoSQL tradicionais.

---

## Tecnologias e Linguagens Utilizadas

* **SWI-Prolog:** Linguagem declarativa baseada em logica de primeira ordem. Responsavel pelo armazenamento da base de conhecimento (fatos) e pela execucao das regras de inferencia dedutiva.
* **Python 3:** Linguagem utilizada para construir a ponte de integracao entre o sistema operacional, o binario do SWI-Prolog e o protocolo HTTP.
* **Flask:** Microframework web em Python responsavel por expor a API RESTful e fornecer os dados estruturados em JSON para o cliente.
* **JavaScript (Vanilla ES6+):** Manipulacao de DOM, chamadas assincronas via Fetch API e gerenciamento de estado do frontend sem frameworks pesados.
* **HTML5 & CSS3:** Interface desenvolvida no padrao SaaS contemporaneo, utilizando CSS Grid, Flexbox, variaveis customizadas (CSS Custom Properties), tipografia Google Fonts (Plus Jakarta Sans e JetBrains Mono) e iconografia vetorial com Lucide Icons.

---

## Arquitetura e Como o Projeto Foi Desenvolvido

A aplicacao foi concebida seguindo uma separacao clara de responsabilidades em tres camadas:

### 1. Camada de Conhecimento e Inferencia (`brasileirao.pl`)

A base Prolog e dividida em tres partes fundamentais:

* **Fatos Primarios:**
  * `time(Posicao, Nome, UF, Regiao, Pontos, Jogos, Vitorias, Empates, Derrotas, GP, GC, SG)`: 20 registros oficiais da 32a rodada.
  * `artilheiro(Posicao, Jogador, Clube, Gols)`: ranking dos principais marcadores do campeonato.
  * `assistente(Posicao, Jogador, Clube, Assistencias)`: ranking dos principais garcons do torneio.

* **Regras de Inferencia:**
  * `todos_times/12`: recupera todos os clubes da base.
  * `libertadores/12`: unifica clubes cuja posicao seja menor ou igual a 6 (G6).
  * `sulamericana/12`: unifica clubes da 7a ate a 12a colocacao.
  * `rebaixamento/12`: unifica clubes que ocupam da 17a a 20a colocacao (Z4).
  * `saldo_positivo/12`: unifica clubes cujo saldo de gols (SG) seja estritamente superior a zero.
  * `por_estado/13`: filtra clubes com base na sigla da Unidade Federativa informada.
  * `por_regiao/13`: filtra clubes pertencentes a regiao geografica especificada.
  * `todos_artilheiros/4` e `todos_assistentes/4`: regras para consulta de atletas.

* **Predicados de Exportacao Formatada:**
  * Predicados auxiliares `exportar_times/1` e `exportar_jogadores/1` utilizam a meta-chamada `forall/2` e introspeccao de termos com `functor/3` e `arg/3` para extrair cada argumento unificado e imprimir em stdout no formato delimitado por pipe (`|`), finalizando a execucao com `halt`.

### 2. Camada de Integracao e API REST (`app.py`)

O servidor Flask atua como intermediario entre a interface web e o interpretador Prolog:

* **Descoberta Inteligente de Executavel:** O script busca automaticamente o binario `swipl` no `PATH` do sistema e em diretorios comuns de instalacao do Windows (como `%LOCALAPPDATA%\Programs\swipl\bin` e `C:\Program Files\swipl\bin`), evitando falhas de configuracao de ambiente.
* **Execucao Headless via Subprocess:** O modulo `subprocess.run` do Python invoca o `swipl` passando as flags `-q` (modo silencioso, suprimindo banners), `-s brasileirao.pl` (carregamento da base) e `-g "exportar_times(...)"` (objetivo de consulta).
* **Serializacao de Dados:** A saida de texto delimitada e capturada, limpa, convertida nos tipos de dados corretos (inteiros e strings) e encapsulada em respostas JSON estruturadas.

### 3. Camada Visual e Dashboard Web (`index.html`)

O frontend foi desenvolvido com foco em legibilidade, desempenho e estetica profissional:

* **Icones Vetoriais:** Utilizacao da biblioteca Lucide Icons, eliminando o uso de emojis e garantindo um visual limpo e corporativo.
* **Terminal de Inspecao Prolog:** Secao interativa que exibe a exata query de predicados executada no motor Prolog para cada filtro selecionado, com destaque de sintaxe e botao para copiar a query para a area de transferencia.
* **Cards de Indicadores (KPIs):** Destaques rapidos no topo com o lider isolado, vagas do G6, artilheiro geral e lider de assistencias.
* **Filtros e Busca Textual em Tempo Real:** Botoes de filtro por zona da tabela, seletores suspensos por estado e regiao, alem de uma barra de pesquisa por texto que filtra os registros instantaneamente no cliente.

---

## Pre-requisitos

Para executar o projeto localmente, certifique-se de possuir:

1. **SWI-Prolog** (versao 9.x ou 10.x recomendada).
2. **Python 3.10** ou superior.
3. Gerenciador de pacotes **pip**.

---

## Como Instalar e Iniciar o Projeto

### Passo 1: Clonar o repositorio

```bash
git clone https://github.com/JoseRCavalli/brasileirao-prolog.git
cd brasileirao-prolog
```

### Passo 2: Instalar as dependencias Python

Crie um ambiente virtual (opcional, mas recomendado) e instale as dependencias:

```bash
# Criacao do ambiente virtual (opcional)
python -m venv venv

# Ativacao no Windows (PowerShell)
.\venv\Scripts\Activate.ps1

# Ativacao no Linux/macOS
source venv/bin/activate

# Instalacao do Flask
pip install -r requirements.txt
```

### Passo 3: Verificar o SWI-Prolog

Certifique-se de que o comando `swipl` esta acessivel ou instalado no seu computador. Para checar, execute no terminal:

```bash
swipl --version
```

Caso o terminal retorne que o comando nao foi encontrado:
* **Windows:** Baixe e instale via [swi-prolog.org](https://www.swi-prolog.org/download/stable) ou via winget (`winget install SWI-Prolog.SWI-Prolog`). O `app.py` tambem detecta automaticamente se instalado na pasta padrao de programas locais.
* **Ubuntu/Debian:** `sudo apt-get install swi-prolog`
* **macOS:** `brew install swi-prolog`

### Passo 4: Executar o servidor

Na raiz da pasta do projeto, execute:

```bash
python app.py
```

A saida do terminal confirmara a deteccao do SWI-Prolog e a inicializacao do servidor Flask:

```text
Iniciando servidor Brasileirao 2026...
-> SWI-Prolog detectado em: C:\Users\...\swipl\bin\swipl.exe
-> Acesse no navegador: http://127.0.0.1:5000
```

### Passo 5: Acessar a aplicacao

Abra seu navegador e acesse:
[http://127.0.0.1:5000](http://127.0.0.1:5000)

---

## Endpoints da API REST

A aplicacao disponibiliza as seguintes rotas JSON:

| Rota | Metodo | Parametros | Descricao |
| :--- | :--- | :--- | :--- |
| `/api/info` | GET | Nenhum | Retorna o status de conexao, caminho do binario e versao do SWI-Prolog |
| `/api/times` | GET | `tipo=todos` | Retorna a tabela completa dos 20 clubes |
| `/api/times` | GET | `tipo=libertadores` | Retorna os clubes classificados no G6 |
| `/api/times` | GET | `tipo=sulamericana` | Retorna os clubes da faixa de Sul-Americana (7o ao 12o) |
| `/api/times` | GET | `tipo=rebaixamento` | Retorna os 4 clubes da zona de rebaixamento (Z4) |
| `/api/times` | GET | `tipo=saldo_positivo` | Retorna apenas clubes com saldo de gols maior que zero |
| `/api/times` | GET | `tipo=estado&valor=SP` | Retorna clubes filtrados por UF (ex: SP, RJ, MG, PR, RS, BA) |
| `/api/times` | GET | `tipo=regiao&valor=Sul` | Retorna clubes filtrados por regiao (ex: Sudeste, Sul, Nordeste, Norte) |
| `/api/jogadores` | GET | `categoria=artilheiros` | Retorna os principais artilheiros do campeonato |
| `/api/jogadores` | GET | `categoria=assistentes` | Retorna os lideres em assistencias do campeonato |

---

## Estrutura de Arquivos

```text
brasileirao-prolog/
├── .gitignore          # Arquivos e pastas ignorados pelo controle de versao
├── app.py              # Servidor Flask e integracao com o motor SWI-Prolog
├── brasileirao.pl      # Base de conhecimento e regras de inferencia em Prolog
├── index.html          # Interface visual reativa e dashboard
├── README.md           # Documentacao tecnica do projeto
└── requirements.txt    # Lista de dependencias Python
```

---

## Licenca

Projeto desenvolvido para fins academicos e didaticos com foco no estudo de paradigmas de programacao logica e integracao de sistemas.
