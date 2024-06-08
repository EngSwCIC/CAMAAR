include Rails.application.routes.url_helpers

class UsersMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.welcome.subject
  #
  def welcome
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end

  def register_user(email)
    @email = email
    mail(to:email,subject: 'Registre-se no Camaar')
  end

end
