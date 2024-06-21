class UserMailer < ApplicationMailer
  default from: 'gabrielbfranca@gmail.com'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome_email.subject
  #
  def welcome_email(user, token)
    @user = user
    @token = token
    @url = edit_user_password_url(reset_password_token: @token)
    mail(to: @user.email, subject: 'Welcome to our platform!')
  end
end
