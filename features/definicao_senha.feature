# language: pt

@issue-105
Funcionalidade: Definição de senha de acesso
  Como usuário
  Quero definir uma senha a partir do link enviado por e-mail
  Para poder acessar o sistema

  Contexto:
    Dado que existe um usuário pendente de senha com o e-mail "usuario@unb.br"
    E o sistema gerou um token de definição de senha válido para esse usuário
    E o usuário acessa a página de definição de senha por meio desse link

  Cenário: Definição de senha com sucesso
    Quando o usuário informa a nova senha "NovaSenhaValida123"
    E informa a confirmação de senha "NovaSenhaValida123"
    E confirma o formulário de definição de senha
    Então o sistema deve registrar a senha para o usuário
    E deve marcar o usuário como apto a acessar o sistema
    E deve exibir uma mensagem de confirmação de cadastro concluído

  Cenário: Tentativa de definição de senha com token inválido ou expirado
    Dado que o usuário acessa a página de definição de senha com um token inválido ou expirado
    Quando o usuário tenta informar uma nova senha
    Então o sistema não deve registrar a nova senha
    E deve exibir uma mensagem informando que o link é inválido ou expirou
    E deve orientar o usuário a solicitar um novo e-mail de cadastro

  Cenário: Tentativa de definição de senha com confirmação divergente
    Quando o usuário informa a nova senha "NovaSenhaValida123"
    E informa a confirmação de senha "OutraSenha456"
    E confirma o formulário de definição de senha
    Então o sistema não deve registrar a senha
    E deve exibir uma mensagem informando que a confirmação de senha não confere

  Cenário: Tentativa de definição de senha que não atende aos requisitos mínimos
    Quando o usuário informa a nova senha "123"
    E informa a confirmação de senha "123"
    E confirma o formulário de definição de senha
    Então o sistema não deve registrar a senha
    E deve exibir uma mensagem informando os requisitos mínimos da senha