# language: pt
Funcionalidade: Visualizar formulários não respondidos
  Como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

  Contexto:
    Dado que existe um usuário participante cadastrado no sistema

  @happy
  Cenário: Participante visualiza a lista de formulários pendentes
    Dado que estou autenticado como participante
    E que estou matriculado na turma "Cálculo 1"
    E que existe um formulário pendente para a turma "Cálculo 1"
    Quando eu acesso a página de avaliações pendentes
    Então devo ver o formulário da turma "Cálculo 1" na lista
    E o status do formulário deve ser "Não respondido"

  @happy
  Cenário: Participante visualiza mensagem quando não possui formulários pendentes
    Dado que estou autenticado como participante
    E que não possuo formulários pendentes nas minhas turmas
    Quando eu acesso a página de avaliações pendentes
    Então devo ver uma mensagem informando que nenhum formulário pendente foi encontrado

  @sad
  Cenário: Participante tenta visualizar formulários de turmas em que não participa
    Dado que estou autenticado como participante
    E que existe um formulário pendente para a turma "Estrutura de Dados"
    E que não estou matriculado na turma "Estrutura de Dados"
    Quando eu acesso a página de avaliações pendentes
    Então não devo ver o formulário da turma "Estrutura de Dados" na lista