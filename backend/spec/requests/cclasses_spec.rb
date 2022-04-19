require 'rails_helper'

RSpec.describe "Cclasses", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/cclasses/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/cclasses/show"
      expect(response).to have_http_status(:success)
    end
  end

end