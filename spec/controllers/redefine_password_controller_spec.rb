require 'simplecov'
SimpleCov.start

require 'rails_helper'

RSpec.describe RedefinePasswordController, type: :controller do
  describe "GET #index" do
    context "when user is authenticated" do
      before do
        allow(controller).to receive(:user_authenticated).and_return(true)
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
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

  describe "POST #redefine" do
    let!(:user) { User.create(email: "test@example.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: "$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu") }
    let(:user_info) { "key_timestamp_test@example.com" }
    let(:valid_params) { { user: { password: "newpassword", password_confirmation: "newpassword" } } }
    let(:invalid_params) { { user: { password: "", password_confirmation: "" } } }

    before do
      cookies.signed[:user_info] = user_info
      allow(User).to receive(:find_by).with(email: "test@example.com").and_return(user)
    end

    context "with all fields blank" do
      it "renders the index template and sets flash error" do
        post :redefine, params: invalid_params
        expect(response).to render_template(:index)
        expect(flash[:error]).to eq("Todos os campos devem ser preenchidos.")
      end
    end

    context "with non-matching passwords" do
      let(:mismatch_params) { { user: { password: "newpassword", password_confirmation: "wrongpassword" } } }

      it "renders the index template and sets flash error" do
        post :redefine, params: mismatch_params
        expect(response).to render_template(:index)
        expect(flash[:error]).to eq("As senhas devem coincidir.")
      end
    end

    context "with valid parameters" do
      it "updates the user password and redirects to login_path" do
        post :redefine, params: valid_params
        user.reload
        expect(BCrypt::Password.new(user.password)).to eq("newpassword")
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Senha redefinida com sucesso!")
      end
    end

    context "when user is not found" do
      before do
        allow(User).to receive(:find_by).with(email: "test@example.com").and_return(nil)
      end

      it "renders the index template and sets flash error" do
        post :redefine, params: valid_params
        expect(response).to render_template(:index)
        expect(flash[:error]).to eq("Usuário não encontrado.")
      end
    end

    context "when update fails" do
      before do
        allow(user).to receive(:update).and_return(false)
      end

      it "renders the index template and sets flash error" do
        post :redefine, params: valid_params
        expect(response).to render_template(:index)
        expect(flash[:error]).to eq("Erro ao redefinir a senha. Tente novamente.")
      end
    end
  end
end
