# language: pt
Funcionalidade: Visualizar templates criados
  Como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Contexto:
    Dado que existe um usuário administrador cadastrado no sistema

  @happy
  Cenário: Administrador visualiza a lista de templates criados
    Dado que estou autenticado como administrador
    E que existe um template chamado "Avaliação de Disciplina" criado por mim
    E que existe um template chamado "Avaliação de Professor" criado por mim
    Quando eu acesso a página de templates
    Então devo ver o template "Avaliação de Disciplina"
    E devo ver o template "Avaliação de Professor"

  @happy
  Cenário: Administrador visualiza mensagem quando não possui templates criados
    Dado que estou autenticado como administrador
    E que não existem templates criados por mim
    Quando eu acesso a página de templates
    Então devo ver a mensagem "Nenhum template foi encontrado" na seção "Meus Templates"

  @sad
  Cenário: Usuário não administrador tenta visualizar a página de templates
    Dado que existe um usuário não administrador cadastrado no sistema
    E que estou autenticado como usuário não administrador
    Quando eu tento acessar a página de templates
    Então devo ver a mensagem "Você não tem permissão para visualizar templates."

  @sad
  Cenário: Administrador só pode excluir templates criados por ele
    Dado que estou autenticado como administrador
    E que existe um template chamado "Meu Template" criado por mim
    E que existe um template chamado "Template de Outro Administrador" criado por outro administrador
    Quando eu acesso a página de templates
    Então devo ver a ação de excluir o template "Meu Template"
    E não devo ver a ação de excluir o template "Template de Outro Administrador"
