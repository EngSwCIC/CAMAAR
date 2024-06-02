# Preview all emails at http://localhost:3000/rails/mailers/admins_mailer
class AdminsMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admins_mailer/welcome
  def welcome
    AdminsMailer.welcome
  end

end
