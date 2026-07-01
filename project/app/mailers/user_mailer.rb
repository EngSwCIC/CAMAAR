##
# Monta as mensagens relacionadas à definição e à redefinição de senhas de usuários.
class UserMailer < ApplicationMailer
  default from: "noreply@camaar.local"

  ##
  # Prepara o e-mail que permite ao usuário definir sua primeira senha.
  #
  # === Argumentos
  #
  # +user+:: User destinatário da mensagem.
  # +token+:: Token em texto puro usado para construir o link temporário.
  #
  # === Retorno
  #
  # Retorna uma ActionMailer::MessageDelivery pronta para envio.
  #
  # === Efeitos colaterais
  #
  # Define variáveis usadas pelo template e monta a mensagem; o envio ocorre quando
  # o chamador solicita a entrega.
  def password_setup(user, token)
    @user = user
    @url = edit_password_setup_url(token)
    mail(to: user.email, subject: "Defina sua senha no CAMAAR")
  end

  ##
  # Prepara o e-mail que permite ao usuário redefinir sua senha.
  #
  # === Argumentos
  #
  # +user+:: User destinatário da mensagem.
  # +token+:: Token em texto puro usado para construir o link temporário.
  #
  # === Retorno
  #
  # Retorna uma ActionMailer::MessageDelivery pronta para envio.
  #
  # === Efeitos colaterais
  #
  # Define variáveis usadas pelo template e monta a mensagem; o envio ocorre quando
  # o chamador solicita a entrega.
  def password_reset(user, token)
    @user = user
    @url = edit_password_reset_url(token)
    mail(to: user.email, subject: "Redefinicao de senha do CAMAAR")
  end
end
