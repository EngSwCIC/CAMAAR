#language: pt
Funcionalidade: Fazer Login

Cenario: Pagina de Login
Dado que nao estou autenticado
E eu vou para a rota "/"
Então eu deveria ver o campo "Email"
E eu deveria ver o campo "Senha"
E eu deveria ver o botão "Login"
