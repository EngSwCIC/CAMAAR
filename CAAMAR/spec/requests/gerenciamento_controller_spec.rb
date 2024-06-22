require 'rails_helper'

RSpec.describe "GerenciamentoController", type: :request do
  describe "GET /gerenciamento/templates" do
    it "returns status code 200 or 302" do
      get "/gerenciamento/templates"
      expect(response).to have_http_status(:ok).or have_http_status(302)
    end
  end

  describe "GET /gerenciamento/results_popup" do
    it "returns http success" do
      get "/gerenciamento/results_popup"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /gerenciamento/generate_csv" do
    it "returns http success" do
      get "/gerenciamento/generate_csv"
      expect(response).to have_http_status(:success)
      expect(response.content_type).to start_with('application/zip')
    end
  end
end
