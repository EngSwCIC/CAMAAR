#language: pt
Funcionalidade: Login no site
    Como um aluno
    Eu quero poder me logar

Contexto:
    Dado que eu estou na pagina de login
    Então eu devo ver um campo "Email"
    E um campo "Senha"

Cenário: Digitar email inválido (triste)
    Quando eu selecionar o campo "Email"
    E digitar "email_invalido"
    E depois selecionar o campo "Senha"
    E digitar "senha123"
    Então devo ver uma mensagem "Falha ao fazer login."

Cenário: Digitar senha inválida (triste)
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


