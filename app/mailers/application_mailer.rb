# Define um mailer base para a aplicação. Todos os mailers da aplicação herdam desta classe.
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
