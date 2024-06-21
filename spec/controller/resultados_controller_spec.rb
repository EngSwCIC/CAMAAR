require 'rails_helper'

RSpec.describe ResultadosController, type: :controller do
  describe "resultados view" do
    describe "correct forms" do
      let(:user) { FactoryBot.create(:user, admin: true) }

      before :each do
        sign_in user
      end

      it "renders index" do
        expect(response).to have_http_status(:ok)
        get :index
      end

      it "calls the model method to get answered forms" do
        expect(FormResponse).to receive(:all)
        get :index
      end
    end
  end

end