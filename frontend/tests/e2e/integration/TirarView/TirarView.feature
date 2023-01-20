#language: pt
Funcionalidade: Retirar a identificação do aluno da resposta dada no questionário
Eu como professor ou coordenador
Quero não ser capaz de visualizar o aluno que respondeu o questionário
A fim de preservar o anonimato das respostas dadas na avaliação

Contexto:
  Dado que eu esteja logado como professor ou coordenador no CAMAAR
  E estou na página de relatório do questionário da turma 1

Cenario: Sou capaz de ver qual aluno respondeu o questionário com sua respectiva resposta (triste)
  Então sou capaz de ver a coluna 'Aluno' na tabela 'Avaliação dos Estudantes'

Cenario: Não sou capaz de ver qual aluno respondeu o questionário com sua respectiva resposta (feliz)
  Então não sou capaz de ver a coluna 'Aluno' na tabela 'Avaliação dos Estudantes'
