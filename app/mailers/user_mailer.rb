class UserMailer < ApplicationMailer
  # Não é necessário informar senha no cadastro — o usuário a define pelo link enviado.

  def invitation(user)
    @user = user
    @url  = password_set_url(token: @user.invitation_token)
    mail(to: @user.email, subject: "Bem-vindo ao CAMAAR — Defina sua senha")
  end

  def reset_password(user)
    @user = user
    @url  = password_reset_url(token: @user.reset_token)
    mail(to: @user.email, subject: "CAMAAR — Redefina sua senha")
  end
end