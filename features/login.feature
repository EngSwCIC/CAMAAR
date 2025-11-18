# language: pt

@issue-104
Funcionalidade: Login de usuário
  Como usuário do sistema
  Quero acessar o sistema usando e-mail ou matrícula e uma senha cadastrada
  Para responder formulários ou gerenciar o sistema

  Contexto:
    Dado que existe um usuário comum cadastrado com:
      | identificador | "usuario@unb.br" |
      | matricula     | "202300000"      |
      | senha         | "SenhaValida123" |
    E existe um usuário administrador cadastrado com:
      | identificador | "admin@unb.br"   |
      | matricula     | "ADM0001"        |
      | senha         | "SenhaAdmin123"  |
    E o usuário está na página de login

  Cenário: Login bem-sucedido com e-mail de usuário comum
    Quando o usuário informa o e-mail "usuario@unb.br"
    E informa a senha "SenhaValida123"
    E confirma o envio do formulário de login
    Então o sistema deve autenticar o usuário
    E deve redirecionar para a página inicial de respondente
    E não deve mostrar a opção de gerenciamento no menu lateral

  Cenário: Login bem-sucedido com matrícula de usuário comum
    Quando o usuário informa a matrícula "202300000"
    E informa a senha "SenhaValida123"
    E confirma o envio do formulário de login
    Então o sistema deve autenticar o usuário
    E deve redirecionar para a página inicial de respondente
    E não deve mostrar a opção de gerenciamento no menu lateral

  Cenário: Login bem-sucedido de administrador
    Quando o usuário informa o e-mail "admin@unb.br"
    E informa a senha "SenhaAdmin123"
    E confirma o envio do formulário de login
    Então o sistema deve autenticar o usuário
    E deve redirecionar para a página inicial de administração
    E deve mostrar a opção de gerenciamento no menu lateral

  Cenário: Login com credenciais inválidas
    Quando o usuário informa o e-mail "usuario@unb.br"
    E informa a senha "senhaErrada"
    E confirma o envio do formulário de login
    Então o sistema não deve autenticar o usuário
    E deve exibir uma mensagem de erro de credenciais inválidas
    E deve permanecer na página de login

  Cenário: Tentativa de login com campos obrigatórios em branco
    Quando o usuário não preenche o campo de identificador
    E não preenche o campo de senha
    E confirma o envio do formulário de login
    Então o sistema deve informar que os campos obrigatórios devem ser preenchidos
    E não deve autenticar o usuário