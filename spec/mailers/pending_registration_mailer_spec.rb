require 'rails_helper'

RSpec.describe PendingRegistrationMailer, type: :mailer do
  let(:pending) do
    PendingRegistration.create!(email: "novo@unb.br", token: "tok123", nome: "Novo", matricula: "999", perfil: "discente")
  end

  describe "#setup_password" do
    it "monta o e-mail com destinatário, assunto e link de definição de senha (Happy Path)" do
      mail = described_class.setup_password(pending)

      expect(mail.to).to eq([ "novo@unb.br" ])
      expect(mail.subject).to eq("Defina sua senha de acesso ao CAMAAR")
      expect(mail.body.encoded).to include("tok123")
    end
  end
end
