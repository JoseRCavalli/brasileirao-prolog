% ==========================================================
% BASE DE CONHECIMENTO: BRASILEIRÃO SÉRIE A 2026
% time(Posicao, Nome, UF, Regiao, Pontos, Jogos, Vitorias, Empates, Derrotas, GP, GC, SG)
% ==========================================================

time(1, 'Palmeiras', 'SP', 'Sudeste', 70, 32, 21, 7, 4, 64, 27, 37).
time(2, 'Flamengo', 'RJ', 'Sudeste', 69, 32, 20, 9, 3, 56, 22, 34).
time(3, 'Cruzeiro', 'MG', 'Sudeste', 54, 32, 16, 6, 10, 51, 46, 5).
time(4, 'Athletico-PR', 'PR', 'Sul', 54, 32, 15, 9, 8, 50, 38, 12).
time(5, 'Fluminense', 'RJ', 'Sudeste', 51, 32, 14, 9, 9, 50, 41, 9).
time(6, 'Atletico-MG', 'MG', 'Sudeste', 50, 32, 14, 8, 10, 44, 38, 6).
time(7, 'Bahia', 'BA', 'Nordeste', 50, 32, 13, 11, 8, 45, 40, 5).
time(8, 'Santos', 'SP', 'Sudeste', 46, 32, 12, 10, 10, 49, 47, 2).
time(9, 'Sao Paulo', 'SP', 'Sudeste', 43, 32, 12, 7, 13, 37, 36, 1).
time(10, 'Bragantino', 'SP', 'Sudeste', 41, 32, 11, 8, 13, 39, 38, 1).
time(11, 'Botafogo', 'RJ', 'Sudeste', 39, 32, 10, 9, 13, 44, 51, -7).
time(12, 'Coritiba', 'PR', 'Sul', 39, 32, 10, 9, 13, 38, 50, -12).
time(13, 'Vasco da Gama', 'RJ', 'Sudeste', 38, 31, 10, 8, 13, 39, 45, -6).
time(14, 'EC Vitoria', 'BA', 'Nordeste', 38, 32, 10, 8, 14, 35, 46, -11).
time(15, 'Mirassol', 'SP', 'Sudeste', 37, 32, 9, 10, 13, 37, 45, -8).
time(16, 'Internacional', 'RS', 'Sul', 35, 32, 8, 11, 13, 36, 40, -4).
time(17, 'Gremio', 'RS', 'Sul', 34, 32, 8, 10, 14, 35, 44, -9).
time(18, 'Corinthians', 'SP', 'Sudeste', 33, 32, 8, 9, 15, 34, 42, -8).
time(19, 'Remo', 'PA', 'Norte', 26, 32, 5, 11, 16, 34, 50, -16).
time(20, 'Chapecoense', 'SC', 'Sul', 21, 31, 4, 9, 18, 32, 63, -31).

% ==========================================================
% ESTATÍSTICAS DE JOGADORES (2026)
% artilheiro(Posicao, Jogador, Clube, Gols)
% assistente(Posicao, Jogador, Clube, Assistencias)
% ==========================================================

artilheiro(1, 'Kevin Viveros', 'Athletico-PR', 21).
artilheiro(2, 'Pedro', 'Flamengo', 16).
artilheiro(3, 'Gabriel Barbosa', 'Santos', 15).
artilheiro(4, 'Carlos Vinicius', 'Gremio', 11).
artilheiro(4, 'Kaio Jorge', 'Cruzeiro', 11).
artilheiro(4, 'Luciano Juba', 'Bahia', 11).

assistente(1, 'Andreas Pereira', 'Palmeiras', 12).
assistente(2, 'Josue', 'Coritiba', 11).
assistente(3, 'Samuel Lino', 'Flamengo', 9).
assistente(4, 'Jorge Carrascal', 'Flamengo', 8).
assistente(4, 'Matheus Pereira', 'Cruzeiro', 8).

% ==========================================================
% REGRAS DE INFERÊNCIA - CLASSIFICAÇÃO DE CLUBES
% ==========================================================

todos_times(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG).

libertadores(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG),
    Pos =< 6.

sulamericana(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG),
    Pos >= 7,
    Pos =< 12.

rebaixamento(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG),
    Pos >= 17.

saldo_positivo(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG),
    SG > 0.

por_estado(UF_Busca, Pos, Nome, UF_Busca, Regiao, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF_Busca, Regiao, Pts, J, V, E, D, GP, GC, SG).

por_regiao(Reg_Busca, Pos, Nome, UF, Reg_Busca, Pts, J, V, E, D, GP, GC, SG) :-
    time(Pos, Nome, UF, Reg_Busca, Pts, J, V, E, D, GP, GC, SG).

% ==========================================================
% REGRAS DE INFERÊNCIA - JOGADORES (GOLS E ASSISTÊNCIAS)
% ==========================================================

todos_artilheiros(Pos, Jogador, Clube, Gols) :-
    artilheiro(Pos, Jogador, Clube, Gols).

todos_assistentes(Pos, Jogador, Clube, Assistencias) :-
    assistente(Pos, Jogador, Clube, Assistencias).

% ==========================================================
% PREDICADOS AUXILIARES DE EXPORTAÇÃO PARA O PYTHON
% ==========================================================

exportar_times(Meta) :-
    forall(Meta, (
        (   functor(Meta, _, 13) ->
            arg(2, Meta, Pos),
            arg(3, Meta, Nome),
            arg(4, Meta, UF),
            arg(5, Meta, Regiao),
            arg(6, Meta, Pts),
            arg(7, Meta, J),
            arg(8, Meta, V),
            arg(9, Meta, E),
            arg(10, Meta, D),
            arg(11, Meta, GP),
            arg(12, Meta, GC),
            arg(13, Meta, SG)
        ;   arg(1, Meta, Pos),
            arg(2, Meta, Nome),
            arg(3, Meta, UF),
            arg(4, Meta, Regiao),
            arg(5, Meta, Pts),
            arg(6, Meta, J),
            arg(7, Meta, V),
            arg(8, Meta, E),
            arg(9, Meta, D),
            arg(10, Meta, GP),
            arg(11, Meta, GC),
            arg(12, Meta, SG)
        ),
        format('~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w|~w~n', [Pos, Nome, UF, Regiao, Pts, J, V, E, D, GP, GC, SG])
    )),
    halt.

exportar_jogadores(Meta) :-
    forall(Meta, (
        arg(1, Meta, Pos),
        arg(2, Meta, Jogador),
        arg(3, Meta, Clube),
        arg(4, Meta, Valor),
        format('~w|~w|~w|~w~n', [Pos, Jogador, Clube, Valor])
    )),
    halt.
