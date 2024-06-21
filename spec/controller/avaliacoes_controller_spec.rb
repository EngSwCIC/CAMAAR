require 'rails_helper'

RSpec.describe AvaliacoesController, type: :controller do
  # include Devise::Test::IntegrationHelpers

  describe "avaliacoes view" do
    describe "correct forms" do
      let(:user) { FactoryBot.create(:user) }

      before :each do
        sign_in user
      end

      it "renders index" do
        expect(response).to have_http_status(:ok)
        get :index
      end

      it "calls the model method to get forms" do
        expect_any_instance_of(User).to receive(:find_pending_forms)
        get :index
      end
    end
  end

end