#language: pt
Funcionalidade: Abrir relatório de uma turma especifica

Eu como professor
Quero saber sobre as avaliações das minhas turmas
A fim de avaliar o desempenho nas turmas que estou ministrando

Contexto:
  Dado que um professor faça login
  E queira abrir o relatório de uma de suas turmas

Cenario: Um professor consegue abrir relatório de uma de suas turmas (feliz)
  Dado que o professor já esteja logado
  E clique em visualizar relatório de uma de suas turmas que tenha respostas cadastradas
  Então deve ser exibido na tela o relatório da turma selecionada

Cenario: Um professor tenta visualizar relatório de turma qua ainda não fez avaliações (triste)
  Dado que o professor já esteja logado 
  E clique em visualizar relatório de uma de suas turmas que ainda não tenha respostas cadastradas
  Então deve ser exibida uma mensagem de aviso escrito "No data available"
