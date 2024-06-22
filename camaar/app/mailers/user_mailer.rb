class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.new_user_email.subject
  #
  def new_user_email
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
