require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe IndexController, type: :controller do
  describe "GET #index" do
    context "when user is authenticated" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
      end

      it "redirects to evaluations_path" do
        get :index
        expect(response).to redirect_to(evaluations_path)
      end
    end

    context "when user is not authenticated" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(false)
      end

      it "redirects to login_path with alert" do
        get :index
        expect(response).to redirect_to(login_path)
        expect(flash[:alert]).to eq("Acesso não autorizado")
      end
    end
  end
end
