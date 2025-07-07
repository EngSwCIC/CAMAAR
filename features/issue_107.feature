# language: pt

Funcionalidade: Redefinição de senha de acesso

  Como usuário
  Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
  Para recuperar o meu acesso ao sistema

  Cenário: Solicitar redefinição de senha
    Dado que estou na tela de Login
    Quando clico em "Esqueci minha senha"
    E informo meu e-mail cadastrado
    Então devo receber um e-mail com um link para redefinir a senha

  Cenário: Redefinir senha com o link do e-mail
    Dado que recebi o e-mail de redefinição de senha
    E clico no link acessando página de redefinição de senha
    E preenchi uma nova senha válida duas vezes
    Quando clicar em "Alterar senha"
    Então devo ser redirecionado para a tela de login com uma mensagem de confirmação

  Cenário: Confirmação de senha diferente da senha inicial
    Dado estou na página de redefinição de senha
    E preenchi "Confirme a senha" diferente de "Senha"
    Quando clicar em "Alterar senha"
    Então uma mensagem alertando que as senhas são diferentes deve ser exibida
