require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'instructions' do
    it 'renders the subject' do
      user = { name: 'Ruan', email: 'xastroboyx11@gmail.com',
               redefinition_link: 'https://redefinition_link.com' }
      mail = described_class.redefine_password(user).deliver_now
      expect(mail.subject).to eq('Sistema CAMAAR: Definição de Senha')
    end

    it 'renders the receiver email' do
      user = { name: 'Ruan', email: 'xastroboyx11@gmail.com',
               redefinition_link: 'https://redefinition_link.com' }
      mail = described_class.redefine_password(user).deliver_now
      expect(mail.to).to eq([user[:email]])
    end
  end
end
