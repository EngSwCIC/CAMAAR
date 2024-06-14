require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /devise/sessions/new" do
    it "should have a sign in route" do
      get "/users/sign_in"

      expect(response).to have_http_status(200)
    end
  end
end
