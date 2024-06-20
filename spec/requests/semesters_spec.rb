require 'rails_helper'

RSpec.describe "Semesters", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/semesters/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/semesters/show"
      expect(response).to have_http_status(:success)
    end
  end

end
