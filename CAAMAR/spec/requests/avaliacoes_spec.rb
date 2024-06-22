require 'rails_helper'

RSpec.describe "Avaliacoes", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/avaliacoes"
      expect(response).to have_http_status(:success)
    end
  end

end
