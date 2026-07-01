# language: pt
Funcionalidade: Visualizar formulários criados
  Como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

  Contexto:
    Dado que estou autenticado como administrador

  @happy
  Cenário: Visualizar meus formulários ativos e acessar relatório de respostas
    Dado que existem formulários criados para o semestre atual
    Quando eu acesso o painel de gerenciamento de formulários
    Então eu devo ver uma lista com todos os formulários criados, exibindo o template base, a turma e o público-alvo de cada um
    E ao acessar um formulário listado devo ver o botão "Exportar CSV"

  @happy
  Cenário: Separar formulários próprios dos formulários de outros administradores do departamento
    Dado que existe um formulário criado por outro administrador do meu departamento
    Quando eu acesso o painel de gerenciamento de formulários
    Então devo ver a seção "Meus Formulários"
    E devo ver a seção "Outros Formulários" com subtítulo "De Administradores do seu Departamento"
    E devo ver o formulário de outro administrador na seção "Outros Formulários"

  @sad
  Cenário: Visualizar listagem quando nenhum formulário foi criado ainda
    Dado que nenhum formulário foi gerado para o semestre vigente
    Quando eu acesso o painel de gerenciamento de formulários
    Então eu devo ver a listagem vazia
    E a mensagem "Nenhum formulário criado por você foi encontrado" deve ser exibida na tela
    E a mensagem "Nenhum formulário de outros administradores encontrado" deve ser exibida na tela

  @sad
  Cenário: Não listar formulários de outro departamento ou semestre anterior
    Dado que existe um formulário criado em outro departamento
    E que existe um formulário criado em semestre anterior
    E que existem formulários criados para o semestre atual
    Quando eu acesso o painel de gerenciamento de formulários
    Então devo ver apenas os formulários vigentes do meu departamento

  @happy
  Cenário: Visualizar formulário cujo template de origem foi removido
    Dado que existe um formulário criado para um template removido
    Quando eu acesso o painel de gerenciamento de formulários
    Então devo ver o formulário com template removido na listagem
    E ao acessar esse formulário devo ver o template como "Template removido"
