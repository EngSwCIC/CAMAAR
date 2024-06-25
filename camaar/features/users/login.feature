# language: pt

Funcionalidade: Login de Usuário
    Como um usuário do sistema
    Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
    Para que eu possa responder formulários ou gerenciar o sistema

    Cenario: Login bem sucedido com e-mail
        Dado que estou na página de login
        Quando eu insiro um e-mail e senha válidos
        E eu clico no botão de login
        Então eu devo ser redirecionado para a página inicial

    # Happy path
    Cenario: Login bem sucedido com matrícula
        Dado que estou na página de login
        Quando eu insiro uma matrícula e senha válidos
        E eu clico no botão de login
        Então eu devo ser redirecionado para a página inicial

    # Sad path
    Cenario: Login mal sucedido com credenciais inválidas
        Dado que estou na página de login
        Quando eu insiro um e-mail, matrícula ou senha inválidos
        E eu clico no botão de login
        Então eu devo ver uma mensagem de erro
