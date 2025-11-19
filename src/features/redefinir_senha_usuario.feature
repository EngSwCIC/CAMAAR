# language: pt
# features/redefinir_senha_usuario.feature

Funcionalidade: Redefinição de Senha
  Eu como Usuário
  Quero redefinir uma senha para o meu usuário a partir do e-mail recebido após a solicitação da troca de senha
  A fim de recuperar o meu acesso ao sistema

  @happy_path
  Cenário: Solicitar link de redefinição com sucesso
    Dado que o usuário "fulano.ativo@email.com" está cadastrado e ativo no sistema
    E eu estou na página de "Login"
    E eu preencho o campo "E-mail" com "fulano.ativo@email.com"
    Quando eu clico em "Esqueci minha senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Se este e-mail estiver cadastrado, um link de redefinição foi enviado."
    E um e-mail de "Redefinição de Senha" deve ser enviado para "fulano.ativo@email.com"

  @sad_path
  Cenário: Solicitar link de redefinição com e-mail em branco
    Dado que eu estou na página de "Login"
    E eu deixo o campo "E-mail" em branco
    Quando eu clico em "Esqueci minha senha"
    Então eu devo permanecer na página de "Login"
    E eu devo ver a mensagem de erro "O campo de e-mail não pode estar vazio."
    E nenhum e-mail deve ser enviado

  @sad_path
  Cenário: Solicitar redefinição de senha com e-mail não cadastrado
    Dado que o e-mail "fulano.invalido@email.com" não está cadastrado no sistema
    E eu estou na página de "Login"
    E eu preencho o campo "E-mail" com "fulano.invalido@email.com"
    Quando eu clico em "Esqueci minha senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Se este e-mail estiver cadastrado, um link de redefinição foi enviado."
    E nenhum e-mail deve ser enviado

  @happy_path
  Cenário: Usar o link de redefinição para cadastrar nova senha
    Dado que o usuário "fulano.ativo@email.com" solicitou um link de redefinição válido
    Quando eu acesso a página "Redefina sua Senha" usando o link válido
    E eu preencho o campo "Nova Senha" com "novaSenhaSuperForte"
    E eu preencho o campo "Confirmar Senha" com "novaSenhaSuperForte"
    E eu clico no botão "Salvar Nova Senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Senha redefinida com sucesso! Você já pode fazer o login."
    E o usuário "fulano.ativo@email.com" deve conseguir logar com a senha "novaSenhaSuperForte"

  @sad_path
  Cenário: Solicitar redefinição de senha com usuário com status "pendente"
    Dado que o usuário "fulano.pendente@email.com" está cadastrado no sistema com o status "pendente"
    E eu estou na página de "Login"
    E eu preencho o campo "E-mail" com "fulano.pendente@email.com"
    Quando eu clico em "Esqueci minha senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Você ainda não definiu sua senha. Por favor, verifique seu e-mail para definir sua senha."
    E nenhum e-mail deve ser enviado