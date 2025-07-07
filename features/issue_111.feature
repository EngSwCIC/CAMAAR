# language: pt

Funcionalidade: Visualização de templates criados

  Como Administrador
  Quero visualizar todos os templates criados
  Para poder editar e/ou deletar um template que eu criei

  Cenário: Listar templates criados
    Dado que estou logado como administrador
    E estou na página "Gerenciamento" de templates
    Quando clicar em "Editar templates"
    Então devo ver uma grade com todos os templates criados
    E cada template deve conter título, descrição, ícone de editar ou deletar

  Cenário: Deletar um template
    Dado que estou logado como administrador
    E estou na página "Gerenciamento" de templates
    E existem templates criados por mim
    Quando clicar em deletar template
    Então o template selecionado deve ser apagado
    E a tela deverá atualizar para não mostrar ele
