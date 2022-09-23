#language: pt
Funcionalidade: Mostrar gráficos nos relatórios

Contexto:
  Dado que um professor faça login
  E abra um relatório de uma de suas turmas

Cenario: Um usuário consegue abrir relatório de uma de suas turmas (feliz)
  Dado que o usuário já esteja logado
  E clique em visualizar relatório de uma de suas turmas que tenha respostas cadastradas
  Então deve ser exibido no relatório gráficos com os dados do questionário da turma selecionada

Cenario: Um usuário tenta visualizar relatório de turma qua ainda não tem respostas (triste)
  Dado que o usuário já esteja logado 
  E clique em visualizar relatório de uma de suas turmas que ainda não tenha respostas cadastradas
  Então não devem ser exibidos gráficos

