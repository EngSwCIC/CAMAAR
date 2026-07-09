# Preview all emails at http://localhost:3000/rails/mailers/user_mailer_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer_mailer/primeiro_acesso
  def primeiro_acesso
    UserMailer.primeiro_acesso
  end
end
