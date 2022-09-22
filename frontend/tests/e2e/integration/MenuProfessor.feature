#language: pt
Funcionalidade: Menu de Professor

Cenario: Pagina de Menu de Coordenador
Dado que nao estou autenticado
Então eu vou para a rota "/#/prof"
E clicar no botão "Questionários"
E eu vou para a rota "/surveys/p"
Então clicar no botão "Voltar"
E eu vou para a rota "/#/"
