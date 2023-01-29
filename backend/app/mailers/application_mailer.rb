class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  def redefine_password(user)
	@redefinition_link = 'user.redefinition_link'
	@user_name = 'user.name'
	# Needs to be a valid email address
	# Replace by yours to test
	@user_email = 'user.email'

    mail(to: @user_email, subject: "Sistema CAMAAR: Definição de Senha")
  end
end
