require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:valid_attributes) {
    { nome: "Template Example" }
  }

  let(:invalid_attributes) {
    { nome: "" }
  }
  describe "GET /index" do
    it "retorna um valor com sucesso" do
      Template.create! valid_attributes
      get templates_url
      expect(response).to be_successful
    end
  end
  describe "GET /show" do
    it "retorna um valor com sucesso" do
      template = Template.create! valid_attributes
      get templates_url(template)
      expect(response).to be_successful
    end
  end
  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Template" do
        expect {
          post templates_url, params: { template: valid_attributes }
        }.to change(Template, :count).by(1)
      end

      it "redirects to the created template" do
        post templates_url, params: { template: valid_attributes }
        expect(response).to redirect_to(templates_url)
      end
    end
  end
end
