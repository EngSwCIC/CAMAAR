require 'rails_helper'

RSpec.describe "Questions", type: :request do
  describe "GET /index" do
    context "no content in model" do
      it "should get index if it has NO CONTENT" do
        get '/questions'
        expect(response).to have_http_status(204)
      end
    end
    context "everything fine" do
      it "should get index should be OK" do
        get '/questions'
        expect(response).to have_http_status(200)
      end
    end
  end
end