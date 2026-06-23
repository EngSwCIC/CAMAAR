# language: pt
Funcionalidade: Visualização de formulários pendentes do participante

  Como um Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Cenário: Participante possui formulários pendentes para responder
    Dado que estou logado no sistema como "Participante"
    Quando eu acesso a página inicial do meu painel (Dashboard)
    E existem formulários ativos das minhas turmas que eu ainda não respondi
    Então o sistema deve listar os formulários pendentes na seção "Avaliações Pendentes"
    E cada item da lista deve ter um botão "Responder Avaliação"

  Cenário: Participante já respondeu todos os formulários
    Dado que estou logado no sistema como "Participante"
    Quando eu acesso a página inicial do meu painel (Dashboard)
    E eu já respondi a todos os formulários ativos das minhas turmas
    Então a seção "Avaliações Pendentes" não deve listar nenhum formulário
    E o sistema deve exibir a mensagem "Você não possui nenhuma avaliação pendente no momento."