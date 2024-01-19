Instruções para o código linguagem_representacao.pl:


Após carregar o código, pode-se utilizar as funções definidas para realizar diferentes operações. Por exemplo, você pode usar a função mover/3 para movimentar um bloco para uma posição livre.

Exemplo:

Para mover o bloco "a" para a posição (2, 1), visto que a posição (2, 1) está livre, você pode executar o seguinte comando: ?- mover(a, 2, 1).

Para verificar a posição de um bloco, pode ser utilizado o seguinte comando: 

?- mover(b,2,1),
verificar_posicao(b, Posicao).

Retorno: Posicao = (2,1,1) % Sendo (X,Y,TamanhoY)

Instruções para o planejador:

Você pode chamar a função plan/4 fornecendo o estado inicial, os objetivos, e uma variável para armazenar o plano. Por exemplo:

?- plan([estado_inicial_aqui], [objetivos_aqui], Plano, Condições).
