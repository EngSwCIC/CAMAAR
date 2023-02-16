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

  describe "POST /survey_answered/:survey_id" do
    it "returns http success" do
      user = double('User', :member_id => '1')
      allow(MembersController).to receive(:get_user_from_token).and_return(user)

      post "/members/survey_answered/1"
      expect(response).to have_http_status(:success)
    end

    it "returns http bad request" do
      user = double('User', :member_id => '1')
      allow(MembersController).to receive(:get_user_from_token).and_return(user)

      post "/members/survey_answered/1"
      post "/members/survey_answered/1"
      expect(response).to have_http_status(:bad_request)
    end
  end

end
