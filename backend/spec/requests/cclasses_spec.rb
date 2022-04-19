require 'rails_helper'

RSpec.describe "Cclasses", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /index" do
    it "returns http success" do
      get "/cclasses/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show/:id" do
    it "returns http success" do
      get "/cclasses/show/1"
      expect(response).to have_http_status(:success)
    end
  end

end
