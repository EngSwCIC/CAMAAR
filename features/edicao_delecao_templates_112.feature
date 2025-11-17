# language: pt

Funcionalidade: Edição e deleção de templates
  Como um Administrador
  Eu quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  De modo que organizar os templates existentes

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E existe um template chamado "Avaliação Docente" criado por mim
    E existem formulários criados baseados neste template

  # CENÁRIOS FELIZES

  Cenário: Editar template existente com sucesso
    Dado que estou na página de gerenciamento de templates
    Quando eu clico em "Editar" no template "Avaliação Docente"
    E eu altero o nome para "Avaliação Docente V2"
    E eu clico em "Adicionar Questão"
    E eu preencho o texto da questão com "Qual sua opinião sobre a didática?"
    E eu seleciono o tipo como "Dissertativa"
    E eu clico no botão "Salvar Alterações"
    Então devo ver a mensagem "Template atualizado com sucesso"
    E o template deve aparecer com o nome "Avaliação Docente V2"
    E os formulários já criados não devem ser afetados

  Cenário: Deletar template com sucesso
    Dado que estou na página de gerenciamento de templates
    Quando eu clico em "Deletar" no template "Avaliação Docente"
    E eu confirmo a exclusão clicando em "Sim, deletar"
    Então devo ver a mensagem "Template deletado com sucesso"
    E o template não deve aparecer na lista de templates
    E os formulários já criados baseados neste template devem continuar funcionando

  # CENÁRIOS TRISTES

  Cenário: Tentar deletar template sem confirmação
    Dado que estou na página de gerenciamento de templates
    Quando eu clico em "Deletar" no template "Avaliação Docente"
    E eu cancelo a exclusão clicando em "Cancelar"
    Então o template deve continuar existindo na lista de templates
    E devo ver a mensagem "Exclusão cancelada"

  Cenário: Editar template removendo questões obrigatórias
    Dado que estou na página de gerenciamento de templates
    Quando eu clico em "Editar" no template "Avaliação Docente"
    E eu removo uma questão obrigatória
    E eu clico no botão "Salvar Alterações"
    Então devo ver a mensagem "Template atualizado com sucesso"
    E os formulários criados devem manter as questões originais
