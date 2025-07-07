# language: pt

Funcionalidade: Criação de templates

  Como administrador
  Quero criar novos templates
  Para gerar formulários de avaliação

  Cenário: Criação de template novo com sucesso
    Dado que estou autenticado como administrador
    E estou na página "Gerenciamento" de templates
    E já importei dados da turma
    E cliquei em "+" para criar template
    E adicionei novas questões
    Quando clicar em "Criar"
    Então o popup de edição deve sumir
    E um novo template deve aparecer na grade como disponível

  Cenário: Criação de template em branco
    Dado que estou autenticado como administrador
    E estou na página "Gerenciamento" de templates
    E já importei dados da turma
    E cliquei em "+" para criar template
    Quando clicar em "Criar"
    Então deverá aparecer uma mensagem de erro avisando que não é possível criar um template em branco
