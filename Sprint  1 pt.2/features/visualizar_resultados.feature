# language: pt
Funcionalidade: Visualizar respostas e resultados de avaliações
  Como Discente
  Quero visualizar minhas respostas e os resultados das avaliações das turmas que participo
  A fim de acompanhar o desempenho e o feedback das avaliações realizadas

  Contexto:
    Dado que o discente está autenticado no sistema
    E acessa o módulo de "Avaliações"

  Cenário: Visualização dos resultados de uma avaliação encerrada (Caminho Feliz)
    Quando o discente seleciona uma avaliação com status "Encerrada"
    E aciona a opção "Ver Resultados"
    Então o sistema deve exibir os resultados consolidados da avaliação
    E apresentar as respostas submetidas pelo discente

  Cenário: Tentativa de visualizar resultados de avaliação ainda aberta (Caminho Triste)
    Quando o discente seleciona uma avaliação com status "Em Andamento"
    E aciona a opção "Ver Resultados"
    Então o sistema deve impedir o acesso aos resultados
    E exibir a mensagem "Os resultados estarão disponíveis após o encerramento da avaliação"
