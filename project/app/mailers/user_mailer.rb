class UserMailer < ApplicationMailer
  default from: "noreply@camaar.local"

  def password_setup(user, token)
    @user = user
    @url = edit_password_setup_url(token)
    mail(to: user.email, subject: "Defina sua senha no CAMAAR")
  end

  def password_reset(user, token)
    @user = user
    @url = edit_password_reset_url(token)
    mail(to: user.email, subject: "Redefinicao de senha do CAMAAR")
  end
end
