#language: pt
Funcionalidade: Mostrar gráficos nos relatórios

Contexto:
  Dado que um usuário faça login
  E abra um relatorio de uma de suas turmas

Cenario: Um usuário consegue abrir relatorio de uma de suas turmas (feliz)
  Dado que o usuário já esteja logado
  E clique em visulizar relatorio de uma de suas turmas que ainda não tenha notas cadastradas
  Entao deve ser exibido no relatório com gráficos com os dados da avaliação da turma selecionada

Cenario: Um usuário tenta visualizar relatorio de turma qua ainda não fez avaliacoes (triste)
  Dado que o usuário já esteja logado 
  E clique em visulizar relatorio de uma de suas turmas que ainda não tenha notas cadastradas
  Entao deve ser exibida uma mensagem de aviso escrito "Ainda não existem notas cadastradas para essa turma"

