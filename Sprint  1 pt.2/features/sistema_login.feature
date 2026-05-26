# language: pt
Funcionalidade: Sistema de Login
  Como Usuário do sistema
  Quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

  Contexto:
    Dado que a página de login do sistema CAMAAR está acessível

  Cenário: Autenticação bem-sucedida de um usuário comum (Respondente) via matrícula
    Dado que existe um usuário comum cadastrado com a matrícula "221007223" e senha "senha123"
    Quando eu preencho o campo de identificação com "221007223"
    E eu preencho o campo de senha com "senha123"
    E eu clico no botão "Entrar"
    Então eu devo ser autenticado com sucesso
    E eu devo ser redirecionado para a página inicial de avaliações

  Cenário: Autenticação bem-sucedida de um usuário administrador via e-mail
    Dado que existe um usuário administrador cadastrado com o e-mail "admin@unb.br" e senha "admin123"
    Quando eu preencho o campo de identificação com "admin@unb.br"
    E eu preencho o campo de senha com "admin123"
    E eu clico no botão "Entrar"
    Então eu devo ser autenticado com sucesso
    E a opção de "Gerenciamento" deve estar visível no menu lateral

  Cenário: Tentativa de login com senha incorreta
    Dado que existe um usuário cadastrado com o e-mail "aluno@unb.br" e senha "senhaCorreta"
    Quando eu preencho o campo de identificação com "aluno@unb.br"
    E eu preencho o campo de senha com "senhaIncorreta"
    E eu clico no botão "Entrar"
    Então o sistema deve exibir a mensagem de erro "E-mail/matrícula ou senha inválidos"
    E eu devo permanecer na página de login