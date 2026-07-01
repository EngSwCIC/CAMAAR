# language: pt
@auth @issue-104
Funcionalidade: Sistema de Login
  Como usuario cadastrado no CAMAAR
  Quero acessar o sistema com email ou matricula e senha
  Para visualizar as funcionalidades disponiveis ao meu perfil

  Contexto:
    Dado que existe um administrador cadastrado com email "admin.cic@unb.br", matricula "000000001" e senha definida "Senha@123"
    E que existe um participante cadastrado com email "acjpjvjp@gmail.com", matricula "190084006" e senha definida "Senha@123"
    E que existe um participante cadastrado com email "andreCarvalhoroure@gmail.com", matricula "200033522" e sem senha definida

  Cenario: Administrador acessa com email e ve o menu administrativo
    Quando o usuario acessa a pagina de login
    E informa o identificador "admin.cic@unb.br"
    E informa a senha "Senha@123"
    E envia o formulario de login
    Entao o sistema deve autenticar o administrador
    E deve exibir o menu lateral com opcoes de gerenciamento

  Cenario: Participante acessa com matricula e ve o menu de participante
    Quando o usuario acessa a pagina de login
    E informa o identificador "190084006"
    E informa a senha "Senha@123"
    E envia o formulario de login
    Entao o sistema deve autenticar o participante
    E deve exibir o menu lateral com formularios pendentes
    E nao deve exibir opcoes administrativas

  Cenario: Usuario nao acessa com senha incorreta
    Quando o usuario acessa a pagina de login
    E informa o identificador "acjpjvjp@gmail.com"
    E informa a senha "SenhaErrada"
    E envia o formulario de login
    Entao o sistema nao deve autenticar o usuario
    E deve exibir a mensagem "Email, matrícula ou senha inválidos"

  Cenario: Usuario ainda sem senha definida nao consegue acessar
    Quando o usuario acessa a pagina de login
    E informa o identificador "200033522"
    E informa a senha "Senha@123"
    E envia o formulario de login
    Entao o sistema nao deve autenticar o usuario
    E deve informar que a senha inicial precisa ser definida antes do acesso
