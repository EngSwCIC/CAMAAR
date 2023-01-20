#language: pt
Funcionalidade: Login no site
    Como um aluno
    Eu quero poder me logar

Contexto:
    Dado que eu estou na pagina de login
    Então eu devo ver um campo "Email"
    E um campo "Senha"
	E um botão "Login"
	E um botão "Esqueci minha senha"

Cenário: Redefinir a senha
    Quando eu clicar no botão "Esqueci minha senha"
    Então devo receber um email de redefinção de senha em meu email
    E devo ver uma mensagem "Um link de redefinição de senha foi enviado para seu email"

Cenário: Tentar fazer login sem digitar nada (triste)
    Dado que nenhum campo foi preenchido
    E eu clicar no botão "Login"
    Então devo ver uma mensagem "Falha ao fazer login."

Cenário: Digitar email incorreto (triste)
    Quando eu selecionar o campo "Email"
    E digitar "email_incorreto"
    E depois selecionar o campo "Senha"
    E digitar "senha_qualquer"
    Então devo ver uma mensagem "Falha ao fazer login."

Cenário: Digitar senha incorreta (triste)
    Quando eu selecionar o campo "Email"
    E digitar "email_correto"
    E depois selecionar o campo "Senha"
    E digitar "senha_incorreta"
    Então devo ver uma mensagem "Falha ao fazer login."

Cenário: Digitar email e senha corretos (feliz)
    Quando eu selecionar o campo "Email"
    E digitar "email_correto"
    E depois selecionar o campo "Senha"
    E digitar "senha_correta"
    Então eu devo ser autenticado
    E eu devo ser redirecionado para a url anterior


