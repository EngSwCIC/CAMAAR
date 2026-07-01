class UsuarioMailer < ApplicationMailer
  # Prepara o email de definição de senha inicial para o usuário.
  #
  # @param usuario [Usuario] destinatário do email, deve possuir +definicao_senha_token+ gerado
  # @return [Mail::Message] mensagem de email pronta para ser entregue
  def definicao_senha(usuario)
    @usuario = usuario
    @url = edit_definicao_senha_url(token: usuario.definicao_senha_token)

    mail(to: usuario.email, subject: "Definição de senha")
  end

  # Prepara o email de redefinição de senha para o usuário.
  #
  # @param usuario [Usuario] destinatário do email, deve possuir +redefinicao_senha_token+ gerado
  # @return [Mail::Message] mensagem de email pronta para ser entregue
  def redefinicao_senha(usuario)
    @usuario = usuario
    @url = edit_redefinicao_senha_url(token: usuario.redefinicao_senha_token)

    mail(to: usuario.email, subject: "Redefinição de senha")
  end
end
