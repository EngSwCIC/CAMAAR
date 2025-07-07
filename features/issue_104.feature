# language: pt

Funcionalidade: Acesso ao sistema por login

  Como Usuário do Sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  Para responder formulários ou gerenciar o sistema

  Cenário: Login com e-mail e senha válidos
    Dado que estou na página de login
    E preenchi um e-mail e senha válidos
    Quando clico em "Entrar"
    Então devo ser autenticado com sucesso
    E redirecionado para a página inicial

  Cenário: Login com matrícula e senha válidas
    Dado que estou na página de login
    E preenchi uma matrícula e a senha válidas
    Quando clico em "Entrar"
    Então devo ser autenticado com sucesso
    E redirecionado para a página inicial

  Cenário: Login como administrador
    Dado que estou na página de login
    E sou um usuário com perfil de administrador
    Quando faço login com credenciais válidas
    Então devo ver a opção de gerenciamento no menu lateral

  Cenário: Login com dados inválidos
    Dado que estou na página de login
    E preenchi um e-mail, matrícula ou senha incorretos
    Quando clico em "Entrar"
    Então devo ver uma mensagem de erro informando que as credenciais são inválidas
