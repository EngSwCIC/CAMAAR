# language: pt

Funcionalidade: Sistema de Login
  Como um usuário do sistema (Administrador ou Participante)
  Eu quero fazer login no sistema
  A fim de acessar as funcionalidades do CAMAAR

  Cenário: Login com sucesso (Caminho Feliz)
    Dado que eu tenho um cadastro ativo no sistema
    E eu acesso a página de "Login"
    Quando eu preencho o campo "Email" com "usuario@example.com"
    E eu preencho o campo "Senha" com "SenhaSegura123"
    E clico no botão "Entrar"
    Então eu devo ser redirecionado para a página inicial do meu perfil
    E o sistema exibe a mensagem "Login realizado com sucesso"

  Cenário: Login com credenciais inválidas (Caminho Triste)
    Dado que eu tenho um cadastro ativo no sistema
    E eu acesso a página de "Login"
    Quando eu preencho o campo "Email" com "usuario@example.com"
    E eu preencho o campo "Senha" com "senhaerrada"
    E clico no botão "Entrar"
    Então eu não devo ser autenticado
    E o sistema exibe a mensagem de erro "Email ou senha inválidos"
