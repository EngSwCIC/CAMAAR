require 'rails_helper'
require "spec_helper"

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

  describe "GET /:id/answers" do
    it "returns answers list" do
      get "/cclasses/1/answers"
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(response_body["rows"]).not_to eq([])
      expect(response_body["columns"]).not_to eq([])
      expect(response_body["average_rows"]).not_to eq([])
      expect(response_body["charts"]).not_to eq([])
      expect(response_body["rows"][0].keys.count).to eq(response_body["average_rows"][0].keys.count)
    end
  end

  describe "GET /:id/answers" do
    it "returns blank answers list" do
      get "/cclasses/2/answers"
      response_body = JSON.parse(response.body)
      expect(response).to have_http_status(:success)
      expect(response_body["rows"]).to eq([])
      expect(response_body["columns"]).to eq([])
      expect(response_body["average_rows"]).to eq([])
      expect(response_body["charts"]).to eq([])
    end
  end
end
