# language: pt

Funcionalidade: Sistema de login
    Eu como Usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    A fim de responder formulários ou gerenciar o sistema

    # Happy Paths

    Cenário: Sucesso no login
        Dado que eu sou um usuário
        E que estou na página de login
        E tiver preenchido o usuário e senha
        Quando eu clicar no botão "login"
        Então eu irei me autenticar no sistema
        E serei redirecionado para a página principal

    # Sad Paths

    Cenário: Preenchimento de usuário errado
        Dado que eu sou um usuário
        E que estou na página de login
        E tiver preenchido o usuário e senha
        Quando eu clicar no botão "login"
        Mas eu preenchi o meu usuário errado
        Então não será possível fazer o login
        E também mostrará uma mensagem de falha ao usuário "usuário/senha incorretos!"

    Cenário: Preenchimento de senha errado
        Dado que eu sou um usuário
        E que estou na página de login
        E tiver preenchido o usuário e senha
        Quando eu clicar no botão "login"
        Mas eu preenchi a minha senha errada
        Então não será possível fazer o login
        E também mostrará uma mensagem de falha ao usuário "usuário/senha incorretos!"