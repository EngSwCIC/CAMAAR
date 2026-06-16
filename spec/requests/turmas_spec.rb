require 'rails_helper'

RSpec.describe "Turmas", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/turmas"
      expect(response).not_to have_http_status(:not_found)
    end
  end

end
