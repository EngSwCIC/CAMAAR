# encoding : UTF-8
# language: pt

Funcionalidade: Login no sistema
        Eu, como usuário do sistema
        Quero acessar o sistema utilizando um e-mail ou matrícula cadastrada
        A fim de responder formulários ou gerenciar o sistema

  Cenário: Login realizado com sucesso usando e-mail válido (happy path)
    Dado que meu usuário está cadastrado com o email "usuario@teste.com" e senha "Senha123"
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123"
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Login realizado com sucesso usando matrícula válida (happy path)
    Dado que minha matrícula "261067676" está cadastrada no sistema e senha "Senha123"
    Quando eu tento realizar o login com matrícula "261067676" e a senha "Senha123"
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Tentativa de login com a senha errada (sad path)
    Dado que meu usuário está cadastrado com o email "usuario@teste.com" e senha "Senha123"
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123."
    Então vejo a mensagem "Falha no login: senha incorreta"
    E permaneço na página de login

  Cenário: Tentativa de login com usuário em branco (sad path)
    Quando eu tento realizar o login sem informar meu email ou matrícula e com senha "Senha123"
    Então vejo a mensagem "Falha no login: informe seu email ou matrícula"
    E permaneço na página de login

  Cenário: Tentativa de login com senha em branco (sad path)
    Quando eu tento realizar o login com email "usuario@teste.com" sem informar minha senha
    Então vejo a mensagem "Falha no login: informe a sua senha"
    E permaneço na página de login

  Cenário: Tentativa de login com usuário com cadastro não efetivado (sad path)
    Dado que meu usuário está cadastrado com o email "usuario@teste.com"
    Dado que minha senha para "usuario@teste.com" não está definida
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123"
    Então vejo a mensagem "Falha no login: usuário existente deve efetivar o seu cadastro por email"
    E permaneço na página de login

  Cenário: Tentativa de login com usuário não cadastrado (sad path)
    Dado que meu email "usuario@teste.com" não está cadastrado no sistema
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123"
    Então vejo a mensagem "Falha no login: usuário não encontrado"
    E permaneço na página de login