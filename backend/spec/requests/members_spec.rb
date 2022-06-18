require 'rails_helper'

RSpec.describe "Members", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /" do
    it "returns http success" do
      get "/members"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/members/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns the first member" do
      get "/members/1"
      response_body = JSON.parse(response.body)
      expect(response_body['id']).to equal(1)
    end
  end


end
