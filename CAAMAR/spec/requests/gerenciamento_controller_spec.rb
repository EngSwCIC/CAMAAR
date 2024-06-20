require 'rails_helper'

RSpec.describe "GerenciamentoController", type: :request do
  describe "GET /gerenciamento/templates" do
    it "returns status code 200 or 302" do
      get "/gerenciamento/templates"
      expect(response).to have_http_status(:ok).or have_http_status(302)
    end
  end
end
