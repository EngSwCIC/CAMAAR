# language: pt
# encoding: utf-8

Funcionalidade: Exibir dados do aluno
Eu como aluno
Quero visualizar os meus dados relacionados a uma turma na qual eu me matriculei
A fim de avaliar o meu desempenho na turma selecionada

  Contexto:
    Dado que eu esteja logado como aluno no CAMAAR
    E eu esteja na pagina de dados do aluno
    E que exista a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)"

  # Cenario Triste
  Cenario: Um ou mais dados do aluno na turma não estão presentes
  Dado que exista a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)" no meu histórico
  E que algum dado meu na turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)" não está disponível
  Quando que eu ir para a página da turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)"
  Então deve aparecer a mensagem "Não disponível" no lugar de um dado indisponível

  # Cenario Feliz
  Cenario: Os dados do aluno na turma estão completos
  Dado que exista a turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)" no meu histórico
  Quando que eu ir para a página da turma "CIC0105 - ENGENHARIA DE SOFTWARE - TA (2021.2 - 35M12)"
  Então deve aparecer todos os meus dados relacionados à turma selecionada