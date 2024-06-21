require 'rails_helper'

RSpec.describe AvaliacoesController, type: :controller do
  # include Devise::Test::IntegrationHelpers

  describe "avaliacoes view" do
    describe "correct forms" do
      before :each do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it "renders index" do
        expect(response).to have_http_status(:ok)
        get :index
      end

      it "gets user from current session" do

      end
      it "calls the model method to get forms" do
        expect(@user).to receive(:find_pending_forms)
        get :index
      end
    end
  end

end