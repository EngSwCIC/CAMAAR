class AdminsMailer < ApplicationMailer
  def new_user_email(admin)
    @admin = admin
    mail(to: email, subject: 'New user signup')
  end

  def user_forgot_email(admin)
    @admin = admin
    mail(to: email, subject: 'Reset email')
  end

  def welcome
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
