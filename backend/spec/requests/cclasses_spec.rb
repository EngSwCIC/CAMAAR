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
  
  describe "GET /reports" do
    it "returns cclasses reports in 2021.2 semester" do
      get "/cclasses/reports?semester=2021.2"
      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response_body[0]['semester']).to eq('2021.2')
      expect(
        response_body[0]['survey_questions']['likert_scale_questions'].length
      ).to be > 0
    end

    it "returns empty cclasses reports if there's no surveys on that semester" do
      get "/cclasses/reports?semester=2000.1"
      response_body = JSON.parse(response.body)

      expect(response).to have_http_status(:success)
      expect(response_body.length).to be 0
    end
  end
end
