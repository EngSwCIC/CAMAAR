# arquivo de especificação da issue "Criar formulário de avaliação" (Sprint 1)
@issue-103
Feature: Criar formulário de avaliação
  Como administrador
  Quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

  Cenário: Criação de formulário com sucesso (feliz)
    Dado que o administrador acessa a página de criação de formulário
    E seleciona um template existente
    E escolhe uma ou mais turmas para aplicar o formulário
    Quando confirma a criação
    Então o sistema deve gerar o formulário e associá-lo às turmas escolhidas

  Cenário: Criação de formulário para várias turmas (feliz)
    Dado que o administrador seleciona um template válido
    E marca várias turmas do semestre atual
    Quando confirma a criação
    Então o sistema deve criar um formulário independente para cada turma selecionada

  Cenário: Tentativa de criação sem template selecionado (triste)
    Dado que o administrador acessa a página de criação de formulário
    E não seleciona nenhum template
    Quando tenta confirmar a criação
    Então o sistema deve impedir o salvamento do formulário

  Cenário: Tentativa de criação sem turmas associadas (triste)
    Dado que o administrador seleciona um template válido
    Mas não escolhe nenhuma turma
    Quando tenta confirmar a criação
    Então o sistema deve rejeitar a criação
    E manter o administrador na tela de seleção
