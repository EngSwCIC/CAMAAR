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
    context "with invalid parameters" do
      it "does not create a new Template" do
        expect {
          post templates_url, params: { template: invalid_attributes }
        }.to change(Template, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post templates_url, params: { template: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { nome: "Updated Template Name" }
      }

      it "updates the requested template" do
        template = Template.create! valid_attributes
        patch template_url(template), params: { template: new_attributes }
        template.reload
        expect(template.nome).to eq("Updated Template Name")
      end
    end
    context "with invalid parameters" do
      it "returns an unprocessable entity status" do
        template = Template.create! valid_attributes
        patch template_url(template), params: { template: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe "DELETE /destroy" do
    it "destroys the requested template" do
      template = Template.create! valid_attributes
      expect {
        delete template_url(template)
      }.to change(Template, :count).by(-1)
    end

    it "redirects to the templates list" do
      template = Template.create! valid_attributes
      delete template_url(template)
      expect(response).to redirect_to(templates_url)
    end
  end
end
