class UserMailer < ApplicationMailer
  def primeiro_acesso(usuario)
    @usuario = usuario

    @url_definir_senha = definir_senha_url(email: @usuario.email)

    mail(
      to: @usuario.email,
      subject: "Bem-vindo ao CAMAAR! Defina sua senha de acesso"
    )
  end
end
