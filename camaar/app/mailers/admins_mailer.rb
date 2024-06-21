class AdminsMailer < ApplicationMailer
  def new_user_email(admin)
    @admin = admin
    mail(to: email, subject: 'New user signup')
  end
end
