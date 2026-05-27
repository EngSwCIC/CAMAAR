# language: pt
Funcionalidade: Visualizar formulários criados
  Como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Contexto:
    Dado que estou autenticado como administrador

  @happy
  Cenário: Visualizar listagem de formulários ativos e acessar relatório de respostas
    Dado que existem formulários criados para o semestre atual
    Quando eu acesso o painel de gerenciamento de formulários
    Então eu devo ver uma lista com todos os formulários criados, exibindo o template base, a turma e o público-alvo de cada um
    E cada formulário listado deve exibir um botão "Gerar Relatório de Respostas"

  @sad
  Cenário: Visualizar listagem quando nenhum formulário foi criado ainda
    Dado que nenhum formulário foi gerado para o semestre vigente
    Quando eu acesso o painel de gerenciamento de formulários
    Então eu devo ver a listagem vazia
    E a mensagem "Nenhum formulário criado para este semestre" deve ser exibida na tela