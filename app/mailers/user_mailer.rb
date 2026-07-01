## Classe de envio de primeiro acesso ao usuário do rails
class UserMailer < ApplicationMailer
  ##
  # === Descrição
  # Metodo que recebe um usuario, define uma url_definir_senha e envia um email com o assunto Bem-vindo ao CAMAAR! Defina sua senha de acesso
  # === Argumentos
  # * usuario.
  # === Retorno
  # * +ActionMailer::MessageDelivery+
  # === Efeitos Colaterais
  # * Cria instancias <tt>@usuario</tt> e <tt>@url_definir_senha</tt> para uso na view do e-mail.

  def primeiro_acesso(usuario)
    @usuario = usuario

    @url_definir_senha = definir_senha_url(email: @usuario.email)

    mail(
      to: @usuario.email,
      subject: "Bem-vindo ao CAMAAR! Defina sua senha de acesso"
    )
  end
end
