# encoding : UTF-8
# language: pt

Funcionalidade: Definição de senha (primeiro acesso)
        Eu, como usuário importado do SIGAA
        Quero definir minha senha a partir de um link enviado por e-mail
        A fim de efetivar meu cadastro e acessar o sistema

  Contexto:
    Dado que o e-mail de usuário "usuario@teste.com" está cadastrado no sistema com senha indefinida
    E um email de definição de senha é enviado para o email "usuario@teste.com"

  Cenário: Definir senha com sucesso (happy path)
    Quando eu acesso o link de definição de senha recebido por e-mail
    E eu informo a nova senha "Senha123" e confirmo a senha "Senha123"
    E eu confirmo a definição de senha
    Então vejo a mensagem "Senha definida com sucesso."
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123"
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Definição de senha com confirmação diferente (sad path)
    Quando eu acesso o link de definição de senha recebido por e-mail
    E eu informo a nova senha "Senha123" e confirmo a senha "Senha321"
    E eu confirmo a definição de senha
    Então vejo a mensagem "Falha na definição de senha: confirmação não confere"

  Cenário: Definição de senha com senha inválida (sad path)
    Quando eu acesso o link de definição de senha recebido por e-mail
    E eu informo a nova senha "123" e confirmo a senha "123"
    E eu confirmo a definição de senha
    Então vejo a mensagem "Falha na definição de senha: senha inválida"
