# language: pt
# encoding: utf-8

Funcionalidade: Pesquisar as turmas utilizando um filtro
Eu como aluno
Quero filtrar as turmas por professor, disciplina ou semestre
A fim de obter as avaliações de turmas mais rapidamente

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na pagina de relatório do aluno

Cenario: Um aluno seleciona um filtro e pesquisa não corresponde a nenhuma turma (triste)
  Dado que eu selecione o filtro 'Disciplina'
  E que a disciplina 'CIC0105' não tenha nenhuma turma cadastrada
  Quando eu clicar no botão "Procurar"
  Então eu deveria ver uma mensagem na tela dizendo "Nenhuma turma encontrada"

  Cenario: Pesquisa com filtro retorna resultados (feliz)
  Dado que eu selecione o filtro 'Professor'
  E que o(a) professor(a) 'Genaina' possui turmas cadastradas no CAMAAR
  Quando eu clicar no botão "Procurar"
  Então eu deveria ver a lista de turmas do(a) professor(a) 'Genaina'

  Cenario: Pesquisa por semestre (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR
  E que as avaliações do semestre '2021-2' foram feitas para a turma 'A' da disciplina 'CIC0105'
  Quando eu selecionar o semestre '2021-2'
  Então eu deveria ver os dados referentes ao semestre selecionado

  Cenario: Pesquisa por semestre (triste)
  Dado que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR
  E que as avaliações do semestre '2021-2' não foram feitas para a turma 'A' da disciplina 'CIC0105'
  Quando eu selecionar o semestre '2021-2'
  Então eu deveria ver a mensagem 'Não há avaliações para esta turma no semestre 2021-2'