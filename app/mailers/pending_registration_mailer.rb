# Envia ao participante importado do SIGAA o link para definição de senha.
class PendingRegistrationMailer < ApplicationMailer
  ##
  # a. Descrição: Envia ao participante importado do SIGAA o link para definição de senha.
  # b. Parâmetros: Recebe 'pending_registration' contendo o e-mail do participante e o token de definição de senha.
  # c. Retorno: envia um e-mail para o participante com o link para definição de senha.
  # d. Efeitos colaterais: nenhum.
  def setup_password(pending_registration)
    @pending = pending_registration
    @link = "/users/password/define?token=#{@pending.token}"
    mail(to: @pending.email, subject: "Defina sua senha de acesso ao CAMAAR")
  end
end
