require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  before(:each) do
    load "#{Rails.root}/db/seeds.rb" 
  end

  describe "GET /" do
    it "returns http success" do
      get "/subjects"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /:id" do
    it "returns http success" do
      get "/subjects/1"
      expect(response).to have_http_status(:success)
    end
  end

end
