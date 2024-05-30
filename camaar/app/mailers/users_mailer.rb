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

  def new_user_email(user)
    @user = user
    mail(to: email, subject: 'New user signup')
  end

  def user_forgot_email(user)
    @user = user
    mail(to: email, subject: 'Reset email')
  end
end
