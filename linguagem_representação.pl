% Definindo blocos e seus tamanhos
bloco(a, 1, 1).
bloco(b, 1, 1).
bloco(c, 1, 2).

% Definindo a configuração inicial na mesa
configuracao_inicial([a, b, c]).

% Definindo as posições na mesa (coordenadas X e Y)
:- dynamic posicao/4. % Agora 4 argumentos: bloco, X, Y, TamanhoY

posicao(a, 1, 1, 1).
posicao(b, 1, 2, 1). 
posicao(c, 3, 1, 2).

% Regra para verificar se um espaço específico está livre na mesa
espaço_livre(X, Y, TamanhoY) :- 
    \+ posicao(_, X, Y, _), 
    Y + TamanhoY - 1 =< 4.

% Regra para verificar a estabilidade de um bloco sobre outro
estavel(BlocoSuperior, BlocoInferior) :- 
    posicao(BlocoSuperior, X1, Y1, T1), 
    posicao(BlocoInferior, X2, Y2, _), 
    Y1 =:= Y2, 
    X1 =:= X2, 
    TamanhoYSuperior is Y1 + T1 - 1,
    \+ (posicao(_, X, Y, _), Y =:= Y1, X >= X1, X =< TamanhoYSuperior).

% Ação de movimento de um bloco para uma posição livre, incluindo empilhamento
mover(Bloco, X, Y) :-
    bloco(Bloco, _, TamanhoY),
    espaço_livre(X, Y, TamanhoY),
    posicao(Bloco, XAnt, YAnt, TamanhoYAnt),
    retract(posicao(Bloco, XAnt, YAnt, TamanhoYAnt)),
    assert(posicao(Bloco, X, Y, TamanhoY)),
    empilhar_blocos_acima(Bloco, X, Y).

% Regra para empilhar os blocos acima do bloco movido, se houver
empilhar_blocos_acima(Bloco, X, Y) :-
    findall(BlocoSuperior, (posicao(BlocoSuperior, XSuperior, YSuperior, _), YSuperior =:= Y + 1), BlocosAcima),
    empilhar_blocos(BlocosAcima, X, Y).

% Regra para empilhar uma lista de blocos acima da posição especificada
empilhar_blocos([], _, _).
empilhar_blocos([BlocoSuperior|Resto], X, Y) :-
    retract(posicao(BlocoSuperior, XSuperior, YSuperior, TamanhoYSuperior)),
    assert(posicao(BlocoSuperior, X, YSuperior, TamanhoYSuperior)),
    empilhar_blocos(Resto, X, Y).
