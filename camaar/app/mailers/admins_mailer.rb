class AdminsMailer < ApplicationMailer
  def welcome
    @greeting = 'Hi'

    mail to: 'admin@unb.com.br'
  end
end
