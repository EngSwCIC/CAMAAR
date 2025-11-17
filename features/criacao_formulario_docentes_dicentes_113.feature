# language: pt

Funcionalidade: Criação de formulário para docentes ou dicentes
  Como um Administrador
  Eu quero escolher criar um formulário para os docentes ou os dicentes de uma turma
  De modo que avaliar o desempenho de uma matéria

  Contexto:
    Dado que estou logado como administrador com email "admin@unb.br"
    E existe uma turma cadastrada com código "CIC0004" e nome "Algoritmos e Programação"
    E existe um template chamado "Avaliação Docente"

  # CENÁRIOS FELIZES

  Cenário: Criar formulário para docentes com sucesso
    Dado que estou na página de gerenciamento de formulários
    Quando eu clico no botão "Novo Formulário"
    E eu seleciono o tipo "Docentes"
    E eu seleciono a turma "CIC0004"
    E eu seleciono o template "Avaliação Docente"
    E eu clico no botão "Criar Formulário"
    Então devo ver a mensagem "Formulário criado com sucesso"
    E o formulário deve estar disponível para os docentes da turma
    E o formulário deve conter as questões do template

  Cenário: Criar formulário para dicentes com sucesso
    Dado que estou na página de gerenciamento de formulários
    Quando eu clico no botão "Novo Formulário"
    E eu seleciono o tipo "Dicentes"
    E eu seleciono a turma "CIC0004"
    E eu seleciono o template "Avaliação Docente"
    E eu clico no botão "Criar Formulário"
    Então devo ver a mensagem "Formulário criado com sucesso"
    E o formulário deve estar disponível para os alunos da turma
    E o formulário deve conter as questões do template

  # CENÁRIOS TRISTES

  Cenário: Tentar criar formulário sem selecionar tipo
    Dado que estou na página de gerenciamento de formulários
    Quando eu clico no botão "Novo Formulário"
    E eu não seleciono o tipo de formulário
    E eu seleciono a turma "CIC0004"
    E eu seleciono o template "Avaliação Docente"
    E eu clico no botão "Criar Formulário"
    Então devo ver a mensagem de erro "É necessário selecionar o tipo de formulário"
    E o formulário não deve ser criado

  Cenário: Tentar criar formulário sem selecionar turma
    Dado que estou na página de gerenciamento de formulários
    Quando eu clico no botão "Novo Formulário"
    E eu seleciono o tipo "Docentes"
    E eu não seleciono uma turma
    E eu seleciono o template "Avaliação Docente"
    E eu clico no botão "Criar Formulário"
    Então devo ver a mensagem de erro "É necessário selecionar uma turma"
    E o formulário não deve ser criado

  Cenário: Tentar criar formulário sem selecionar template
    Dado que estou na página de gerenciamento de formulários
    Quando eu clico no botão "Novo Formulário"
    E eu seleciono o tipo "Dicentes"
    E eu seleciono a turma "CIC0004"
    E eu não seleciono um template
    E eu clico no botão "Criar Formulário"
    Então devo ver a mensagem de erro "É necessário selecionar um template"
    E o formulário não deve ser criado
