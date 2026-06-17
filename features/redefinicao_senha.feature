# encoding : UTF-8
# language: pt

Funcionalidade: Redefinição de senha
        Eu, como usuário cadastrado
        Quero redefinir minha senha quando eu a esquecer
        A fim de recuperar meu acesso ao sistema

  Contexto:
    Dado que meu usuário está cadastrado com o email "usuario@teste.com" e senha "Senha123"

  Cenário: Solicitar redefinição de senha com sucesso (happy path)
    Quando eu clico em "Esqueci minha senha"
    E eu informo o email "usuario@teste.com"
    E eu solicito a redefinição de senha
    Então vejo a mensagem "Solicitação de redefinição de senha enviada."
    E um email de redefinição de senha é enviado para o email "usuario@teste.com"

  Cenário: Redefinir senha com sucesso através do link (happy path)
    Dado que eu solicitei a redefinição de senha para o email "usuario@teste.com"
    Quando eu acesso o link de redefinição de senha recebido por e-mail
    E eu informo a nova senha "NovaSenha123" e confirmo a senha "NovaSenha123"
    E eu confirmo a redefinição de senha
    Então vejo a mensagem "Senha redefinida com sucesso."
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "NovaSenha123"
    Então vejo a mensagem "Login realizado com sucesso."
    E sou direcionado para a página inicial

  Cenário: Após redefinir a senha, a senha antiga deixa de funcionar (sad path)
    Dado que eu solicitei a redefinição de senha para o email "usuario@teste.com"
    Quando eu acesso o link de redefinição de senha recebido por e-mail
    E eu informo a nova senha "NovaSenha123" e confirmo a senha "NovaSenha123"
    E eu confirmo a redefinição de senha
    Então vejo a mensagem "Senha redefinida com sucesso."
    Quando eu tento realizar o login com o email "usuario@teste.com" e a senha "Senha123"
    Então vejo a mensagem "Falha no login: senha incorreta"
    E permaneço na página de login

  Cenário: Solicitar redefinição para email não cadastrado (sad path)
    Dado que meu email "naoexiste@teste.com" não está cadastrado no sistema
    Quando eu clico em "Esqueci minha senha"
    E eu informo o email "naoexiste@teste.com"
    E eu solicito a redefinição de senha
    Então vejo a mensagem "Falha na redefinição de senha: usuário não encontrado"

  Cenário: Solicitar redefinição sem informar email (sad path)
    Quando eu clico em "Esqueci minha senha"
    E eu solicito a redefinição de senha sem informar meu email
    Então vejo a mensagem "Falha na redefinição de senha: informe seu email"

  Cenário: Redefinição com confirmação diferente (sad path)
    Dado que eu solicitei a redefinição de senha para o email "usuario@teste.com"
    Quando eu acesso o link de redefinição de senha recebido por e-mail
    E eu informo a nova senha "NovaSenha123" e confirmo a senha "NovaSenha321"
    E eu confirmo a redefinição de senha
    Então vejo a mensagem "Falha na redefinição de senha: confirmação não confere"

  Cenário: Redefinição com senha inválida (sad path)
    Dado que eu solicitei a redefinição de senha para o email "usuario@teste.com"
    Quando eu acesso o link de redefinição de senha recebido por e-mail
    E eu informo a nova senha "123" e confirmo a senha "123"
    E eu confirmo a redefinição de senha
    Então vejo a mensagem "Falha na redefinição de senha: senha inválida"
