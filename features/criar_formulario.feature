# language: pt

Funcionalidade: Criar formulário de avaliação
  Como um professor ou administrador
  Quero poder criar um formulário de avaliação
  Para que os alunos possam avaliar a disciplina ou turma

  Contexto:
    Dado que eu estou logado como professor
    E eu estou na página de criação de formulários

  Cenário: Criação de formulário com sucesso (Happy Path)
    Quando eu escolho um template para o formulário
    E escolho uma turma para enviar o formulário
    E envio o formulário
    Então eu devo ver a mensagem "Formulário criado com sucesso"
    E o formulário deve estar disponível para os alunos da turma selecionada

  Cenário: Tentativa de criação sem template (Sad Path)
    Quando eu não escolho um template para o formulário
    E escolho uma turma para enviar o formulário
    E envio o formulário
    Então eu devo ver a mensagem "Selecione um template para criar o formulário"

  Cenário: Tentativa de criação sem turma (Sad Path)
    Quando eu não escolho uma turma para enviar o formulário
    E escolho um template para o formulário
    E envio o formulário
    Então eu devo ver a mensagem "Selecione pelo menos uma turma"

