# language: pt
Funcionalidade: Redefinição de Senha (Recuperação)
  Como Usuário cadastrado
  Quero solicitar a recuperação de senha e definir uma nova credencial
  A fim de recuperar o meu acesso ao sistema

  # --- ETAPA 1: SOLICITAÇÃO DO LINK DE RECUPERAÇÃO ---
  @happy
  Cenário: Solicitar link de recuperação de senha com sucesso
    Dado que estou na página de login
    Quando eu clico em "Esqueci minha senha"
    E preencho o campo "E-mail" com "usuario.valido@email.com"
    E clico em "Enviar link de recuperação"
    Então devo ver a mensagem "Um link de redefinição foi enviado para o seu e-mail"

  @sad
  Cenário: Tentar solicitar recuperação com e-mail não cadastrado ou com erro de digitação
    Dado que estou na página de login
    Quando eu clico em "Esqueci minha senha"
    E preencho o campo "E-mail" com "usuarrio.errado@email.com"
    E clico em "Enviar link de recuperação"
    Então devo ver a mensagem de erro "E-mail não encontrado no sistema"

  # --- ETAPA 2: REDEFINIÇÃO DA SENHA VIA LINK ---
  @happy
  Cenário: Redefinição de senha com sucesso através de token válido
    Dado que solicitei a recuperação de senha e recebi o e-mail com o link de redefinição
    Quando eu acesso o link de redefinição do e-mail dentro do prazo de validade
    E preencho a nova senha com "MinhaNovaSenha77"
    E confirmo a nova senha com "MinhaNovaSenha77"
    E clico em "Atualizar Senha"
    Então minha senha deve ser atualizada no sistema
    E devo ser redirecionado para a página de login

  @sad
  Cenário: Tentar redefinir a senha utilizando um link expirado (Regra de Negócio)
    Dado que solicitei a recuperação de senha e recebi o e-mail há mais de 24 horas
    Quando eu tento acessar o link de redefinição contido no e-mail
    Então eu devo ser redirecionado para a página de solicitação de recuperação
    E devo ver a mensagem de erro "Este link de recuperação expirou"
