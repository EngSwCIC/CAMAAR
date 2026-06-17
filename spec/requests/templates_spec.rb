require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true) }

  before do
    post login_path, params: { email: admin.email, password: "senha" }
  end

  describe "POST /templates" do
    it "fails to create a template without title" do
      post templates_path, params: {
        template: {
          titulo: "",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "Pergunta 1", tipo: "aberta" }
          ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Nome do Template não pode ficar em branco")
      expect(Template.count).to eq(0)
    end

    it "fails to create a template without any valid questions" do
      post templates_path, params: {
        template: {
          titulo: "Template 1",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "", tipo: "aberta" }
          ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("O template deve ter ao menos uma pergunta")
      expect(Template.count).to eq(0)
    end

    it "creates a template with valid data" do
      post templates_path, params: {
        template: {
          titulo: "Template 1",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "Pergunta 1", tipo: "aberta" }
          ]
        }
      }
      expect(response).to redirect_to(templates_path)
      expect(Template.count).to eq(1)
      expect(Template.first.perguntas.count).to eq(1)
    end
  end
end
