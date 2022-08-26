#language: pt
Funcionalidade: Visualizar avaliações de todas as turmas do semestre atual
Eu como administrador
Quero visualizar as avaliações de todas a turmas de uma maneira rápida e simples
A fim de avaliar o desempenho das turmas do CIC no semestre atual

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu estou na página de avaliações das turmas

Cenario: Redireciona usuário não autorizado (triste)
  Então eu deveria ser redirecionado para 'home'
