#language: pt
Funcionalidade: Menu de Aluno

Cenario: Pagina de Menu de Aluno
Dado que nao estou autenticado
Então eu vou para a rota "/#/aluno/"
E clicar no botão "Questionários"
E eu vou para a rota "/surveys/a/"
Então clicar no botão "Voltar"
E eu vou para a rota "/#/"
