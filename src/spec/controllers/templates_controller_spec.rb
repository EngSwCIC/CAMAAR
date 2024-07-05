require 'rails_helper'

RSpec.describe TemplatesController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Template" do
        expect {
          post :create, params: { template: { semestre: "2024/1", nome: "Modelo de Avaliação", user_id: user.id, questoes_ids: [1, 2, 3] } }
        }.to change(Template, :count).by(1)
      end

      it "redirects to the templates list" do
        post :create, params: { template: { semestre: "2024/1", nome: "Modelo de Avaliação", user_id: user.id, questoes_ids: [1, 2, 3] } }
        expect(response).to redirect_to(templates_url)
      end
    end
  end

  describe "PUT #update" do
    let(:template) { create(:template, user: user) }

    context "with invalid params" do
      it "does not update the template" do
        put :update, params: { id: template.id, template: { semestre: "", nome: "Novo Nome" } }
        template.reload
        expect(template.semestre).not_to eq("")
        expect(template.nome).not_to eq("Novo Nome")
      end

      it "renders the edit template with unprocessable_entity status" do
        put :update, params: { id: template.id, template: { semestre: "", nome: "Novo Nome" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#template_params" do
    it "permits expected parameters" do
      params = ActionController::Parameters.new(
        template: {
          user_id: user.id,
          semestre: "2024/1",
          nome: "Modelo de Avaliação",
          questoes_ids: [1, 2, 3]
        }
      )

      allow(controller).to receive(:params).and_return(params)

      permitted_params = controller.send(:template_params)

      expect(permitted_params).to include(
        :user_id, :semestre, :nome, questoes_ids: []
      )
    end
  end
end
