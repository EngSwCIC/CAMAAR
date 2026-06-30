require 'rails_helper'

RSpec.describe "Templates", type: :request do
  include Devise::Test::IntegrationHelpers
  # Cria um usuário de teste para conseguirmos passar pelo before_action :authenticate_user!
  let(:user) { User.create!(email: "docente@unb.br", password: "password123", nome: "Docente Teste", matricula: "123456789", perfil: "docente") }
  
  # Cria um template no banco para testarmos as rotas de edição e exclusão
  let!(:template_existente) { Template.create!(nome: "Template Original") }

  before do
    # Simula o login usando o helper do Devise
    sign_in user
  end

  describe "GET /templates/new" do
    it "renderiza a página de criação com sucesso" do
      get new_template_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /templates" do
    context "com parâmetros válidos (Happy Path)" do
      let(:valid_params) { { template: { nome: "Novo Template de Prova" } } }

      it "cria um novo template no banco e redireciona" do
        expect {
          post templates_path, params: valid_params
        }.to change(Template, :count).by(1)
        
        expect(response).to redirect_to(Template.last)
        expect(flash[:notice]).to eq("Template criado com sucesso.")
      end
    end

    context "com parâmetros inválidos (Sad Path)" do
      let(:invalid_params) { { template: { nome: "" } } }

      it "não cria o template e re-renderiza a página (status 422)" do
        expect {
          post templates_path, params: invalid_params
        }.not_to change(Template, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /templates/:id/edit" do
    it "renderiza a página de edição com sucesso" do
      get edit_template_path(template_existente)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /templates/:id" do
    context "com parâmetros válidos (Happy Path)" do
      it "atualiza os dados do template e redireciona" do
        patch template_path(template_existente), params: { template: { nome: "Nome Atualizado" } }
        template_existente.reload
        
        expect(template_existente.nome).to eq("Nome Atualizado")
        expect(response).to redirect_to(template_existente)
        expect(flash[:notice]).to eq("Template atualizado com sucesso.")
      end
    end

    context "com parâmetros inválidos (Sad Path)" do
      it "rejeita a atualização e re-renderiza a página" do
        patch template_path(template_existente), params: { template: { nome: "" } }
        template_existente.reload
        
        expect(template_existente.nome).to eq("Template Original") # Garante que não mudou
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /templates/:id" do
    it "remove o template do banco de dados e redireciona (Happy Path)" do
      expect {
        # A exclusão agora exige a confirmação marcada (caixa "Remover").
        delete template_path(template_existente), params: { confirmar: "1" }
      }.to change(Template, :count).by(-1)
      
      expect(response).to redirect_to(templates_path)
      expect(flash[:notice]).to eq("Template removido com sucesso.")
    end
  end
end