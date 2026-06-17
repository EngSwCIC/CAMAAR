class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM_ADDRESS", "camaar@gmail.com")
  layout "mailer"
end
