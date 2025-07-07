# language: pt

Funcionalidade: Visualização de formulários não respondidos

  Como participante de uma turma
  Quero visualizar todos os formulários de uma turma em que estou matriculado
  Para poder escolher qual irei responder

  Cenário: Exibir lista de formulários não respondidos
    Dado que estou logado como participante
    E estou matriculado em uma ou mais turmas
    Quando acesso a página "Avaliações"
    Então devo ver uma grade com todos os formulários não respondidos
    E cada formulário deve mostrar o nome da disciplina, turma e data de vencimento

  Cenário: Formulário não deve ser listado após resposta
    Dado que estou logado como participante
    E estou matriculado em uma ou mais turmas
    Quando acesso a página "Avaliações"
    E respondo um formulário
    Então o formulário não deve mais ser listado aqui
