# language: pt

Funcionalidade: Visualização de formulários para responder
  Como um Participante de uma turma
  Eu quero visualizar os formulários não respondidos das turmas em que estou matriculado
  De modo que poder escolher qual irei responder

  Contexto:
    Dado que estou logado como aluno com email "aluno@unb.br"
    E estou matriculado na turma "CIC0004"
    E estou matriculado na turma "CIC0097"
    E estou na página de formulários disponíveis

  # CENÁRIOS FELIZES

  Cenário: Visualizar formulários pendentes para responder
    Dado que existe um formulário não respondido para a turma "CIC0004"
    E existe um formulário não respondido para a turma "CIC0097"
    Quando eu acesso a página de formulários disponíveis
    Então devo ver a lista de formulários pendentes
    E devo ver o nome do formulário "Avaliação Semestral"
    E devo ver o código da turma "CIC0004"
    E devo ver a data limite para responder
    E devo ver o botão "Responder" para cada formulário
    E devo poder clicar para abrir o formulário

  Cenário: Não visualizar formulários já respondidos
    Dado que já respondi o formulário da turma "CIC0004"
    E o formulário não respondido da turma "CIC0097" está disponível
    Quando eu acesso a página de formulários
    Então não devo ver o formulário da turma "CIC0004" na lista de pendentes
    E devo ver apenas o formulário da turma "CIC0097" como pendente
    E devo poder acessar minha resposta anterior na aba "Respondidos"

  Cenário: Visualizar abas de formulários pendentes e respondidos
    Dado que tenho formulários respondidos e pendentes
    Quando eu acesso a página de formulários
    Então devo ver a aba "Pendentes" com formulários não respondidos
    E devo ver a aba "Respondidos" com formulários já respondidos
    E devo poder clicar em cada aba para alternar
    E a aba "Pendentes" deve estar selecionada por padrão

  Cenário: Filtrar formulários por turma
    Dado que tenho formulários de várias turmas
    Quando eu seleciono um filtro por turma "CIC0004"
    E eu clico em "Filtrar"
    Então devo ver apenas formulários da turma "CIC0004"
    E os formulários de outras turmas devem desaparecer

  # CENÁRIOS TRISTES

  Cenário: Visualizar mensagem quando não há formulários pendentes
    Dado que respondeu todos os formulários das minhas turmas
    Quando eu acesso a página de formulários
    Então devo ver a mensagem "Não há formulários pendentes"
    E devo ver a aba "Respondidos" com meus formulários respondidos
    E não devo ver o botão "Responder"

  Cenário: Tentar responder formulário com prazo expirado
    Dado que existe um formulário cuja data limite já passou
    Quando eu acesso a página de formulários
    Então devo ver o formulário com status "Prazo expirado"
    E o formulário não deve ter o botão "Responder" habilitado
    E devo ver a mensagem "Este formulário já expirou"

  Cenário: Não visualizar formulários de turmas que não estou matriculado
    Dado que não estou matriculado na turma "CIC0202"
    E existe um formulário para a turma "CIC0202"
    Quando eu acesso a página de formulários
    Então não devo ver o formulário da turma "CIC0202"
    E devo ver apenas formulários das turmas que estou matriculado
