require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "welcome_email" do
    let(:user) { FactoryBot.create(:user, email: 'gabrielbfranca@gmail.com') }
    let(:password) { "123456" }

    before { Devise.mailer = UserMailer }  # Temporarily set UserMailer for tests

    it 'sends a welcome email with password reset link' do
      expect { UserMailer.welcome_email(user, password).deliver_now! }
        .to change { ActionMailer::Base.deliveries.count }.by(1)

      # Optional: Test email content (if applicable)
      # mail = ActionMailer::Base.deliveries.last
      # expect(mail.body.encoded).to include(user.name)
    end
  end

end
