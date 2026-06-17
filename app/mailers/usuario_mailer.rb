class UsuarioMailer < ApplicationMailer
  def definicao_senha(usuario)
    @usuario = usuario
    @url = edit_definicao_senha_url(token: usuario.definicao_senha_token)

    mail(to: usuario.email, subject: "Definição de senha")
  end

  def redefinicao_senha(usuario)
    @usuario = usuario
    @url = edit_redefinicao_senha_url(token: usuario.redefinicao_senha_token)

    mail(to: usuario.email, subject: "Redefinição de senha")
  end
end
