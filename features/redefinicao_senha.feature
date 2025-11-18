# language: pt

@issue-107
Funcionalidade: Redefinição de senha
  Como usuário
  Quero redefinir minha senha a partir do link recebido após solicitar a troca
  Para recuperar meu acesso ao sistema

  Contexto:
    Dado que existe um usuário cadastrado com o e-mail "usuario@unb.br"
    E o usuário solicitou a redefinição de senha
    E o sistema gerou um token válido de redefinição de senha
    E o usuário acessa a página de redefinição por meio do link enviado por e-mail

  Cenário: Redefinir senha com sucesso
    Quando o usuário informa a nova senha "SenhaNova123"
    E informa a confirmação "SenhaNova123"
    E confirma o envio do formulário
    Então o sistema deve atualizar a senha do usuário
    E deve exibir uma mensagem informando que a senha foi redefinida com sucesso
    E deve redirecionar o usuário para a página de login

  Cenário: Token inválido ou expirado
    Dado que o usuário acessa a página com um token inválido ou expirado
    Quando tenta enviar uma nova senha
    Então o sistema deve recusar a redefinição
    E deve exibir a mensagem "Link inválido ou expirado"
    E deve orientar o usuário a solicitar um novo e-mail

  Cenário: Confirmação da senha divergente
    Quando o usuário informa a senha "SenhaNova123"
    E informa a confirmação "OutraSenha"
    E confirma o envio
    Então o sistema não deve atualizar a senha
    E deve exibir a mensagem "As senhas não coincidem"

  Cenário: Senha fora dos critérios mínimos
    Quando o usuário informa a senha "123"
    E informa a confirmação "123"
    E confirma o envio
    Então o sistema deve recusar a atualização
    E deve exibir os requisitos mínimos da senha