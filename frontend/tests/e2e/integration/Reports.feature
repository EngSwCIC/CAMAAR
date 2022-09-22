#language: pt
Funcionalidade: Visualizar avaliações de todas as turmas do semestre atual
  Eu como administrador
  Quero visualizar as avaliações de todas a turmas de uma maneira rápida e simples, podendo aplicar filtro por
  diciplina, professor e/ou nota
  A fim de avaliar o desempenho das turmas do CIC no semestre atual

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu estou na página de avaliações das turmas

Cenario: Não há nenhum questionário registrado nesse semestre (triste)
  Dado que não há questionários cadastrados nesse semestre no sistema
  Então eu deveria ver uma mensagem na tela dizendo "Nenhum questionário encontrado"

Cenario: Há questionários registrados nesse semestre mas não selecionamos qual (feliz)
  Dado que há questionários cadastrados nesse semestre no sistema
  Então eu deveria ver uma mensagem na tela dizendo "Nenhum questionário selecionado"

Cenario: Conseguimos visualizar um gráfico ao selecionar o questionário (feliz)
  Dado que há questionários cadastrados nesse semestre no sistema
  E selecionei um questionário
  Então eu deveria ver um gráfico na tela com as informações do questionário selecionado
