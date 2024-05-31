# language: pt
Funcionalidade: Visualização de formulários para responder

  Eu como usuário participante de uma turma
  Quero visualizar os formulários não respondidos atribuídos ao meu perfil, de acordo com as turmas que estou matriculado
  com o intuito de escolher qual formulário irei responder.

  # FELIZ
  Cenário: Visualizar os formulários não respondidos atribuídos ao meu perfil de acordo com as turmas em que estou participando
    Dado que estou logado no sistema
    Quando acesso a página de avaliações
    Então visualizo a lista de todos os formulários pendentes de resposta atribuídos ao meu usuário de acordo com as turmas que participo
    E seleciono o formulário de acordo com a turma que participo
    Então sou redirecionado para a página de resposta para preencher o formulário

# TRISTE
  Cenário: Erro ao carregar lista completa de formulários para visualização
    Dado que estou logado no sistema
    Quando acesso a página de avaliações
    Então visualizo a lista de formulários incompleta


  # TRISTE
  Cenário: Erro ao carregar lista de formulários
    Dado que estou logado no sistema
    Quando acesso a página de avaliações
    E tento visualizar a lista de formulários
    E ocorre um erro ao carregar a lista de formulários de acordo com a turma
    Então vejo uma mensagem de erro informando que não foi possível carregar a lista de formulários
    E sou instruído a tentar novamente mais tarde
