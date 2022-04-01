# language: pt
# encoding: utf-8

Funcionalidade: Pesquisar utilizando relatório um filtro
Eu como professor 
Quero saber mais informações sobre as minhas turmas
A fim de avaliar o desempenho das turmas

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na pagina de relatório do aluno

  # Cenario Triste digitar um filtro que não há no respectivo histórico
  Cenario: Um Aluno digita uma turma em que não participou durante toda sua graduação até o momento
  Dado que exista a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)"
  E que ela não esteja presente no seu histórico
  E que não estejá cursando está matéria no semestre corrente
  Quando eu clicar no botão "Procurar"
  Então deve aparecer uma mensagem na tela dizendo "Turma não encontrada"

  # Cenario Feliz digitar uma turma que há no respectivo histórico devolvendo seus dados
  Cenario: O professor digita uma turma em que participou em algum momento durante toda sua graduação 
  Dado que eu digite na barra de pesquisa  a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)"
  E que exista a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)" no meu histórico e presente no CAMAAR
  Quando eu clicar no botão "Procurar"
  Então deve aparecer uma mensagem na tela dizendo "Turma encontrada"