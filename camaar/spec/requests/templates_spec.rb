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
end
