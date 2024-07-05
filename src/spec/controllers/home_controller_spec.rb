require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @formularios" do
      get :index
      expect(assigns(:formularios)).not_to be_nil
      # Add further expectations based on your data setup
    end
  end

  describe "GET #gerenciamento" do
    it "returns a successful response" do
      get :gerenciamento
      expect(response).to be_successful
    end

    it "assigns @templates and @turmas" do
      get :gerenciamento
      expect(assigns(:templates)).not_to be_nil
      expect(assigns(:turmas)).not_to be_nil
      # Add further expectations based on your data setup
    end
  end

  describe "POST #enviar_formularios" do
    let(:template) { create(:template) }
    let(:turma) { create(:turma, professor: user) }

    context "with valid params" do
      it "creates new formularios" do
        expect {
          post :enviar_formularios, params: { turma_ids: [turma.id], template_id: template.id }
        }.to change(Formulario, :count).by(1)
      end

      it "redirects to gerenciamento_path with notice on success" do
        post :enviar_formularios, params: { turma_ids: [turma.id], template_id: template.id }
        expect(flash[:notice]).to match(/Formulário\(s\) criado\(s\) com sucesso!/)
      end
    end

    context "with invalid params" do
      it "redirects to gerenciamento_path with alert" do
        post :enviar_formularios, params: { turma_ids: [], template_id: nil }
        expect(flash[:alert]).to match(/Nenhuma turma selecionada!/)
      end
    end
  end
end
