#language: pt
Funcionalidade: Abrir relatorio de uma turma especifica

Eu como professor
Quero saber sobre as avaliações das minhas turmas
A fim de avaliar o desempenho das turmas que estou ministrando

Contexto:
  Dado que um professor faça login
  E queira abrir o relatorio de uma de suas turmas

Cenario: Um professor consegue abrir relatorio de uma de suas turmas (feliz)
  Dado que o professor já esteja logado
  E clique em visulizar relatorio de uma de suas turmas que ainda não tenha notas cadastradas
  Entao deve ser exibido na tela o relatorio de desempenho da turma selecionada

Cenario: Um professor tenta visualizar relatorio de turma qua ainda não fez avaliacoes (triste)
  Dado que o professor já esteja logado 
  E clique em visulizar relatorio de uma de suas turmas que ainda não tenha notas cadastradas
  Entao deve ser exibida uma mensagem de aviso escrito "Ainda não existem notas cadastradas para essa turma"
