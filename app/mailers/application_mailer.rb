# frozen_string_literal: true

# Base mailer class for the application.
# Sets default values for sender address and layout.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
