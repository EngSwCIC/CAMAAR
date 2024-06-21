# language: pt
Funcionalidade: Sistema de login

  Eu como usuário do CAMAAR
  Quero acessar o sistema na minha conta com e-mail e senha já pré-cadastradas
  A fim de responder formulários ou gerenciar o sistema

  # FELIZ
  Cenário: Login bem-sucedido
    Dado que estou na página de login do CAMAAR
    Quando insiro meu e-mail e senha corretos
    E submeto o formulário de login
    Então sou redirecionado para a página de avaliações do sistema CAMAAR

  # TRISTE
  Cenário: Tentativa de login com e-mail não cadastrado
    Dado que estou na página de login do CAMAAR
    Quando insiro um e-mail não cadastrado
    E insiro uma senha válida ou não
    E submeto o formulário de login
    Então recebo uma mensagem de erro informando que o e-mail não está cadastrado
    E permaneço na página de login

  # TRISTE
  Cenário: Tentativa de login com senha incorreta
    Dado que estou na página de login do CAMAAR
    Quando insiro um e-mail cadastrado
    E insiro uma senha não condizente com a do e-mail cadastrado
    E submeto o formulário de login
    Então recebo uma mensagem de erro informando que a senha está incorreta
    E permaneço na página de login

  # TRISTE
  Cenário: Tentativa de acesso à página sem estar logado
    Dado que estou tentando acessar uma página protegida do sistema CAMAAR
    Quando tento acessar a página sem estar logado
    Então sou redirecionado para a página de login
    E recebo uma mensagem informando que devo estar logado para acessar a página
