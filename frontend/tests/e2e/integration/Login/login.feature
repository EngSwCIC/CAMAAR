#language: pt
Funcionalidade: Login no site
    Como um aluno
    Eu quero poder me logar

Contexto:
    Dado que estou na rota "/"
    Então eu deveria ver o campo "Email"
    E eu deveria ver o campo "Senha"
	E eu deveria ver o botão "Login"

Cenário: Tentar fazer login sem digitar email (triste)
    Dado que o campo email não foi preenchido
    E eu clicar no botão "Login"
    Então eu deveria ver uma mensagem "E-Mail Obrigatório"

Cenário: Tentar fazer login sem digitar senha (triste)
    Quando eu selecionar o campo email e digitar "email_qualquer"
    Dado que o campo senha não foi preenchido
    E eu clicar no botão "Login"
    Então eu deveria ver uma mensagem "Senha Obrigatória"

Cenário: Digitar email incorreto (triste)
    Quando eu selecionar o campo email e digitar "email_incorreto"
    E selecionar o campo senha e digitar "senha_qualquer"
    E eu clicar no botão "Login"
    Então devo ver uma mensagem "Email ou senha invalidos"

Cenário: Digitar senha incorreta (triste)
    Quando eu selecionar o campo email e digitar "acjpjvjp@gmail.com"
    E selecionar o campo senha e digitar "aaaaaaaaaaaa"
    E eu clicar no botão "Login"
    Então devo ver uma mensagem "Email ou senha invalidos"

Cenário: Digitar email e senha corretos (feliz)
    Quando eu selecionar o campo email e digitar "acjpjvjp@gmail.com"
    E selecionar o campo senha e digitar "123"
    E eu clicar no botão "Login"
    Então eu devo ser redirecionado para a rota "/home"


