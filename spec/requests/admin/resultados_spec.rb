require 'rails_helper'

RSpec.describe "Admin::Resultados", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/resultados/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/resultados/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /exportar_csv" do
    it "returns http success" do
      get "/admin/resultados/exportar_csv"
      expect(response).to have_http_status(:success)
    end
  end

end
