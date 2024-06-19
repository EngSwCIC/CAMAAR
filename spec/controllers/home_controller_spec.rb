require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe HomeController, type: :controller do
  describe "GET #index" do
    context "when user is authenticated" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
      end

      it "renders the home template" do
        get :index
        expect(response).to render_template(:home)
      end
    end

    context "when user is not authenticated" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(false)
      end

      it "redirects to root_path with alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso não autorizado")
      end
    end
  end
end
