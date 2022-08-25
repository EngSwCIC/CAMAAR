#language: pt
Funcionalidade: Visualizar avaliações de todas as turmas do semestre atual
Eu como administrador
Quero visualizar as avaliações de todas a turmas de uma maneira rápida e simples
A fim de avaliar o desempenho das turmas do CIC no semestre atual

Contexto:
  Dado que eu esteja logado como administrador no CAMAAR
  E eu estou na página de avaliações das turmas

Cenario: Não há nenhuma pesquisa registrada nesse semestre (triste)
  Dado que não há pesquisas cadastradas nesse semestre no sistema
  Então eu deveria ver uma mensagem na tela dizendo 'Nenhuma pesquisa cadastrada ainda'

# Cenario Feliz o administrador consegue visualizar os resultados das pesquisas
Cenario: Visualiza os resultados das pesquisas do semestre atual no CAMAAR (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está cadastrada no CAMAAR
  Então eu deveria ver a disciplina 'CIC0105' da turma 'A' com uma média associada

Cenario: Ordenar de forma descrescente as médias das turmas no CAMAAR (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está visível na tabela no CAMAAR
  E a turma 'A' tem nota '5'
  E que a turma 'B' da disciplina 'CIC0105' está visível na tabela no CAMAAR
  E a turma 'B' tem nota '2'
  Então eu deveria ver a disciplina 'CIC0105' da turma 'A' acima da disciplina 'CIC0105' da turma 'B'

Cenario: Ordenar de forma crescente as médias das turmas no CAMAAR (feliz)
  Dado que a turma 'A' da disciplina 'CIC0105' está visível na tabela no CAMAAR
  E a turma 'A' tem nota '5'
  E que a turma 'B' da disciplina 'CIC0105' está visível na tabela no CAMAAR
  E a turma 'B' tem nota '2'
  Então eu deveria ver a disciplina 'CIC0105' da turma 'B' acima da disciplina 'CIC0105' da turma 'A'
