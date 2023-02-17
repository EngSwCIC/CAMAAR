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
  #
  # Recebe um objeto member que deve possuir essencialmente 5 informações:
  #
  # - name, representando o nome do usuário.
  # - email, representando o email do usuário.
  # - password, representando a senha cadastrada para o usuário.
  #
  # É retornado um objeto de email, que pode ser enviado com o método deliver_now
  def redefine_password_email(member, password)
    base_url = 'http://localhost:8080/#/cadastrar/'
    @redefinition_link = base_url + member[:redefinition_link]
    @user_name = member[:name]
    @user_email = member[:email]
	@password = password

    mail(to: @user_email, subject: "Sistema CAMAAR: Definição de Senha")
  end
end
