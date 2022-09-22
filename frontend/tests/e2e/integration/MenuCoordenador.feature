#language: pt
Funcionalidade: Menu de Coordenador

Cenario: Pagina de Menu de Coordenador
Dado que nao estou autenticado
Então eu vou para a rota "/#/"
E clicar no botão "Questionários"
E eu vou para a rota "/surveys/c"
Então clicar no botão "Voltar"
E eu vou para a rota "/#/"
