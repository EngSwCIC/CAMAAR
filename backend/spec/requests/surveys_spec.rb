require 'rails_helper'

RSpec.describe "Surveys", type: :request do
  describe "GET /index" do
    context "everything fine" do
      it "should get index should be OK" do
        get '/surveys'
        expect(response).to have_http_status(200)
      end
    end
    context "no content in model" do
      it "should get index if it has NO CONTENT" do
        get '/surveys'
        expect(response).not_to have_http_status(204)
      end
    end
  end
end
