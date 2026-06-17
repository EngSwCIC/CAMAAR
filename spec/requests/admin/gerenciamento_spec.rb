require 'rails_helper'

RSpec.describe "Admin::Gerenciamentos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/gerenciamento/index"
      expect(response).to have_http_status(:success)
    end
  end

end
