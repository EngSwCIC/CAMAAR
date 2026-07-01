##
# Classe base dos e-mails enviados pela aplicação.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
