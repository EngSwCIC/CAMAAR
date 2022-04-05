Funcionalidade:  Questionario com listas de perguntas separados por disciplina
Eu como aluno 
quero clicar em um questionário
a fim de responder às perguntas desse questionário

Contexto:
  Dado que eu esteja logado como aluno no CAMAAR
  E eu esteja na página com todos os questionários
  E que existam questionários disponiveis para clicar

Cenario: Um Aluno deseja acessar um questionário (feliz)
  Dado que eu estou na pagina com todos os questionários
  Quando eu tentar clicar no questionário
  Então eu devo conseguir abrir o questionário
  E eu devo conseguir ter acesso as perguntas
  E eu devo conseguir responder as perguntas

Cenario: Um Aluno deseja acessar um questionário (triste)
  Dado que eu estou na pagina com todos os questionários
  Quando eu tentar clicar no questionário
  E eu não consigo acessar o questionário
  Então eu deveria ver uma mensagem de "Erro"

Cenario: Um Aluno deseja acessar um questionário (triste)
  Dado que eu estou na pagina com todos os questionários
  E eu não consigo visualizar nenhum questionário
  E eu não consigo acessar o questionário
  Então eu deveria ver uma pagina vazia
 