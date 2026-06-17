require 'rails_helper'

RSpec.describe "Formularios", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/formularios/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /responder" do
    it "returns http success" do
      get "/formularios/responder"
      expect(response).to have_http_status(:success)
    end
  end

end
