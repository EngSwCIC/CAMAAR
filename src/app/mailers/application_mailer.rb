##
# Configura a base para todos os emails na aplicação.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
