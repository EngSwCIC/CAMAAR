require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /devise/sessions/new" do
    it "works! (now write some real specs)" do
      get "/users/sign_in"

      expect(response).to have_http_status(200)
    end
  end
end
