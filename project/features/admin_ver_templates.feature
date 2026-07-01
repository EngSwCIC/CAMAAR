# language: pt
Funcionalidade: Administrador gerenciar templates criados

  Como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

  Cenário: Visualização dos templates criados
    Dado que o administrador está na interface de templates
    Quando o sistema carrega os templates
    Então ele deverá ver somente os templates criados por ele
    E deverá ter a opção de deletar ou editar esses templates

  Cenário: Tentativa de visualizar templates criados por outro administrador
    Dado que o administrador está na interface de templates
    Quando ele tenta acessar diretamente um template criado por outro administrador
    Então ele deverá ver uma mensagem de erro de permissão "Você não tem acesso a esse template"