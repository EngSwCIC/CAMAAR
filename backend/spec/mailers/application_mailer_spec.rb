require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'instructions' do
    let(:user) { 'user'}
    let(:mail) { described_class.redefine_password(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Sistema CAMAAR: Definição de Senha')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq(['user.email'])
    end

  end
end
