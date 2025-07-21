require 'rails_helper'

RSpec.describe ImportadorSigaa, type: :service do
  describe '#processar' do
    let(:json_data) do
      [
        {
          "id" => 1,
          "code" => "CIC0001",
          "classCode" => "1",
          "name" => "OAC",
          "time" => "24T23",
          "semester" => "2025.1",
          "dicente" => [
            {
              "nome" => "Aluno Teste",
              "matricula" => "123456789",
              "usuario" => "aluno@email.com",
              "formacao" => "Graduação",
              "ocupacao" => "Estudante",
              "email" => "aluno@email.com"
            }
          ],
          "docente" => {
            "nome" => "Prof. Lamar",
            "usuario" => "lamar@email.com",
            "formacao" => "Doutorado",
            "ocupacao" => "Docente",
            "email" => "lamar@email.com",
            "departamento" => "CIC"
          }
        }
      ]
    end

    before do
      ActionMailer::Base.deliveries.clear
      Devise.mappings[:pessoa] ||= Devise::Mapping.new(:pessoa, {})
    end

    it 'cria novo aluno e envia email de redefinição de senha' do
      expect {
        ImportadorSigaa.new(json_data).processar
      }.to change(Pessoa, :count).by(2) # 1 aluno + 1 professor

      aluno = Pessoa.find_by(email: "aluno@email.com")
      expect(aluno).not_to be_nil

      # verifica se o token foi gerado
      expect(aluno.reset_password_token).not_to be_nil
      expect(aluno.reset_password_sent_at).not_to be_nil

      # verifica o e-mail enviado
      mail = ActionMailer::Base.deliveries.find { |m| m.to.include?("aluno@email.com") }
      expect(mail).not_to be_nil
      expect(mail.subject).to match(/Redefinir senha/i)
    end
  end
end
