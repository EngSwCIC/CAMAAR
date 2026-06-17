require 'rails_helper'

RSpec.describe "Admin::Formularios", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/admin/formularios/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/admin/formularios/create"
      expect(response).to have_http_status(:success)
    end
  end

end
