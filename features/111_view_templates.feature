# language: pt
Funcionalidade: Visualização dos templates criados (#111)
  Como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que estou autenticado como administrador
    E estou na página "gerenciamento/templates" do sistema

  Cenário: Exibir a lista de templates criados pelo administrador atual
    Dado que existem templates cadastrados para o administrador atual:
      | nome                  |
      | Template Avaliação 1  |
      | Template Avaliação 2  |
    Quando eu visualizo a listagem de templates
    Então devo ver o card do template "Template Avaliação 1" na listagem
    E devo ver o card do template "Template Avaliação 2" na listagem
    E não devo ver templates criados por outros administradores

  Cenário: Administrador sem templates cadastrados
    Dado que não existem templates cadastrados para o administrador atual
    Quando eu visualizo a listagem de templates
    Então devo ver a mensagem "Nenhum template cadastrado ainda"
    E a listagem de templates fica vazia
