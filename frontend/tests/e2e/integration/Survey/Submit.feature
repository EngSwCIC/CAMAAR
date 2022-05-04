#language: pt
Funcionalidade: Submissão de questionário avaliativo sobre a turma

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na página de responder relatório

Cenario: O aluno preencheu o questionário corretamente e deseja enviar (feliz)
  Dado que eu preenchi corretamente os dados do questionário
  Quando eu tentar clicar no botão "Enviar"
  Então eu deveria ver uma mensagem de "Sucesso"
  E ser redirecionado para a página de listagem de questionários

Cenario: O aluno preencheu o questionário incorretamente e deseja enviar (triste)
  Dado que eu preenchi incorretamente os dados do questionário
  Quando eu tentar clicar no botão "Enviar"
  Então eu deveria ver uma mensagem de "Erro"
