##
# Esta classe é responsavel por gerar e disparar emails.
#
# Para funcionar é necessário uma conta de email válida, servindo de remetente
# e outro email válido (sem senha) servindo de destinatário. 
#
# As credenciais da conta do remetente estão definidas em variáveis de ambiente.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  # #
  # Gera um email de redefinição de senha de acordo com as informações do aluno.
  def redefine_password_email(member, password)
    base_url = 'http://localhost:8080/#/cadastrar/'
    @redefinition_link = base_url + member[:redefinition_link]
    @user_name = member[:name]
    @user_email = member[:email]
	@password = password

    mail(to: @user_email, subject: "Sistema CAMAAR: Definição de Senha")
  end
end
