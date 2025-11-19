# language: pt
Funcionalidade: Edição e deleção de templates (#112)
  Como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

  Contexto:
    Dado que estou autenticado como administrador
    E estou na página "gerenciamento/templates" do sistema

  Cenário: Editar um template sem alterar os formulários já criados
    Dado que existe o template "Avaliação Docente 2025.1" associado a 2 formulários já criados
    Quando eu acesso a edição do template "Avaliação Docente 2025.1"
    E altero o nome do template para "Avaliação Docente 2025.1 - Revisado"
    E salvo as alterações do template
    Então devo ver a mensagem "Template atualizado com sucesso"
    E devo ver o card do template "Avaliação Docente 2025.1 - Revisado" na listagem

  Cenário: Deletar um template sem remover os formulários já criados
    Dado que existe o template "Avaliação Docente 2025.1" associado a 3 formulários já criados
    Quando eu excluo o template "Avaliação Docente 2025.1"
    E confirmo a exclusão do template
    Então devo ver a mensagem "Template removido com sucesso"
    E o template "Avaliação Docente 2025.1" não aparece mais na listagem de templates
