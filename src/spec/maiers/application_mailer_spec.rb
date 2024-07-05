require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'default settings' do
    it 'has the correct default from email' do
      expect(ApplicationMailer.default[:from]).to eq('from@example.com')
    end
  end
end
