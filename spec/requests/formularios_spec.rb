require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  # Assumindo que você usa FactoryBot para criar dados falsos (Mocks)
  let(:user) { create(:user, role: 'discente') }
  let(:discente) { create(:discente, user: user) }
  let(:turma) { create(:turma, codigo: "CIC0097", nome: "BANCOS DE DADOS") }
  let(:template) { create(:template) }
  let(:formulario) { create(:formulario, turma: turma, template: template, status: 'Aberto') }

  before do
    # Loga o usuário no sistema usando o helper do Devise
    sign_in user
  end

  describe "GET /formularios" do
    context "Cenário Feliz: quando o discente está matriculado e ainda NÃO respondeu" do
      before do
        create(:matricula, discente: discente, turma: turma)
        formulario # Chama a variável let para criar no banco
      end

      it "retorna sucesso HTTP 200 e exibe a turma na página" do
        get formularios_path

        expect(response).to have_http_status(:success)
        expect(response.body).to include("CIC0097")
        expect(response.body).to include("BANCOS DE DADOS")
      end
    end

    context "Cenário Triste: quando o discente já respondeu o formulário" do
      before do
        create(:matricula, discente: discente, turma: turma)
        create(:envio_formulario, formulario: formulario, discente: discente)
      end

      it "NÃO exibe o formulário na página" do
        get formularios_path
        expect(response.body).not_to include("CIC0097")
      end
    end

    context "Cenário Triste: quando o discente NÃO tem matrículas" do
      it "exibe a mensagem de ausência de formulários pendentes" do
        get formularios_path

        expect(response.body).to include("Você não possui formulários pendentes para este semestre")
      end
    end
  end
end
