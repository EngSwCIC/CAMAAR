# language: pt

Funcionalidade: Criar formulário de avaliação
  Como um Administrador
  Eu quero criar um formulário de avaliação instanciando um template para uma turma
  A fim de disponibilizar a avaliação para os participantes responderem

  Cenário: Criar formulário válido para uma turma (Caminho Feliz)
    Dado que eu estou logado como "Administrador"
    E existe um template chamado "Avaliação Padrão"
    Quando eu acesso a página de "Criar Avaliação"
    E seleciono o template "Avaliação Padrão"
    E seleciono a "Turma de Engenharia de Software"
    E clico em "Disponibilizar Formulário"
    Então o sistema gera um formulário associado a essa turma
    E notifica os alunos da turma
    E o sistema exibe a mensagem "Formulário disponibilizado com sucesso"

  Cenário: Criar formulário sem selecionar template (Caminho Triste)
    Dado que eu estou logado como "Administrador"
    Quando eu acesso a página de "Criar Avaliação"
    E seleciono a "Turma de Engenharia de Software"
    Mas deixo o campo de "Template" vazio
    E clico em "Disponibilizar Formulário"
    Então o sistema não deve gerar o formulário
    E exibe a mensagem de erro "Você precisa selecionar um template para o formulário"
