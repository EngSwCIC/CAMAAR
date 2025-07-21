#language: pt
Funcionalidade: Edição e deleção de templates
  Eu como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Contexto:
    Dado que eu estou logado como admin
    E que eu estou na página de gerenciamento de templates do CAMAAR

  Cenário: Excluir um template com sucesso (HAPPY)
    Quando eu clicar no botão "Excluir template" no "Template 1"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver "O Template 1 foi excluído!"
    E eu não devo ver "Template 1"

  Cenário: Editar um template com sucesso (HAPPY)
    Quando eu clicar no botão "Editar template" no "Template 2"
    E eu preencher o template
    E eu clicar no botão "Salvar Edições"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver "Edição feita com sucesso"

  Cenário: Falha ao tentar excluir um template inexistente (SAD)
    Quando eu clicar no botão "Excluir template" no "Template 3"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver "Falha ao excluir: o Template 3 não existe."
    E eu não devo ver "Template 3"



  Cenário: Falha ao tentar editar um template inexistente (SAD)
    Quando eu clicar no botão "Editar template" no "Template 4"
    Então eu devo estar na página de gerenciamento de templates do CAMAAR
    E eu devo ver "Falha ao editar: o Template 4 não existe."
    E eu não devo ver "Template 4"