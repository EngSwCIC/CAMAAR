require 'rails_helper'

RSpec.describe "MainControllers", type: :request do
  describe "GET /main/index" do
    it "returns status code 200 or 302" do
      get "/main/index"
      expect(response).to have_http_status(:ok).or have_http_status(302)
    end
  end
end
