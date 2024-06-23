require 'simplecov'
SimpleCov.start

require 'rails_helper'

RSpec.describe RegistrationsController, type: :controller do
  describe "POST #create" do
    context "with valid parameters and available email/key" do
      let(:user_params) { { email: "newuser@example.com", password: "password", password_confirmation: "password", key: "valid_key" } }
      
      before do
        allow(SignUpAvailable).to receive(:check_availability).and_return(true)
      end

      it "creates a new user and redirects to login_path" do
        post :create, params: { user: user_params }
        expect(response).to redirect_to(login_path)
        expect(flash[:notice]).to eq("Usuário criado com sucesso!")
      end
    end

    context "with blank parameters" do
      let(:user_params) { { email: "", password: "", password_confirmation: "", key: "" } }

      it "renders :create and sets flash error" do
        post :create, params: { user: user_params }
        expect(response).to render_template(:create)
        expect(flash[:error]).to eq("Todos os campos devem ser preenchidos.")
      end
    end

    context "with email already taken" do
      let(:user_params) { { email: "existing_user@example.com", password: "password", password_confirmation: "password", key: "TOKEN_587" } }

      before do
        SignUpAvailable.create(email: "existing_user@example.com", key: "TOKEN_587")
        User.create(email: "existing_user@example.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: "$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu")
      end

      it "renders :create and sets flash error" do
        post :create, params: { user: user_params }
        expect(response).to render_template(:create)
        expect(flash[:error]).to eq("Email já cadastrado, entre em contato com o administrador.")
      end
    end

    context "with invalid email/key combination" do
      let(:user_params) { { email: "newuser@example.com", password: "password", password_confirmation: "password", key: "invalid_key" } }

      before do
        allow(SignUpAvailable).to receive(:check_availability).and_return(false)
      end

      it "renders :create and sets flash error" do
        post :create, params: { user: user_params }
        expect(response).to render_template(:create)
        expect(flash[:error]).to eq("Email ou chave de cadastro inválidos, entre em contato com seu coordenador.")
      end
    end

    context "with password confirmation mismatch" do
      let(:user_params) { { email: "newuser@example.com", password: "password", password_confirmation: "mismatch", key: "valid_key" } }

      before do
        allow(SignUpAvailable).to receive(:check_availability).and_return(true)
      end

      it "renders :create and sets flash error" do
        post :create, params: { user: user_params }
        expect(response).to render_template(:create)
        expect(flash[:error]).to eq("As senhas devem coincidir.")
      end
    end
  end
end
