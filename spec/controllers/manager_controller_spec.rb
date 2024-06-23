require 'simplecov'
SimpleCov.start

require 'rails_helper'

RSpec.describe ManagerController, type: :controller do
  describe "GET #index" do
    context "when user is authenticated and admin" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:admin_user?).and_return(true)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context "when user is authenticated but not admin" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
        allow(controller).to receive(:admin_user?).and_return(false)
      end

      it "redirects to root_path with alert" do
        get :index
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("Acesso não autorizado")
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
