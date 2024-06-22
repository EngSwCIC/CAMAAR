include Rails.application.routes.url_helpers

class UsersMailer < ApplicationMailer
  def register_user(email)
    @email = email
    mail(to:email,subject: 'Registre-se no Camaar')
  end

end
