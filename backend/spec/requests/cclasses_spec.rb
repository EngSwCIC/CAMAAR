require 'rails_helper'

RSpec.describe "Cclasses", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /" do
    it "returns http success" do
      get "/cclasses"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/cclasses/1"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id/members" do
    it "returns members list" do
      get "/cclasses/1/members"
      response_body = JSON.parse(response.body)
      expect(response_body[44]['name']).to eq('MARISTELA TERTO DE HOLANDA')
    end
  end
  
  describe "GET /performance" do
    it "should throw an error if semester is not in request" do
      pending
      get "/cclasses/performance"
    end

    it "should throw an error cclasses performances if user is not admin" do
      pending
      get "/cclasses/performance?semester=2021.2"
    end

    it "returns cclasses performances in 2021.2 semester" do
      pending
      get "/cclasses/performance?semester=2021.2"
    end
  end
end
