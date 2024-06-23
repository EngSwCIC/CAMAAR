require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe AuthenticationController, type: :controller do
  describe "GET #login" do
    it "renders the login template" do
      get :login
      expect(response).to render_template('login')
    end
  end

  describe "POST #process_login" do
    let!(:user) { User.create(email: "test@example.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: BCrypt::Password.create("password"), session_key: nil) }

    context "when email and password are blank" do
      it "redirects to login_path with an error message" do
        post :process_login, params: { email: "", password: "" }
        expect(flash[:error]).to eq("Email e Senha devem ser prenchidos.")
        expect(response).to redirect_to(login_path)
      end
    end

    context "when email and password are correct" do
      before do
        allow(User).to receive(:authenticate).and_return(true)
        allow(user).to receive(:generate_session_key).and_return("valid_session_key")
      end

      it "creates a session cookie and redirects to evaluations_path" do
        post :process_login, params: { email: "test@example.com", password: "password" }
        expect(response).to redirect_to(root_path)
        expect(cookies.signed[:user_info]).to be_present
      end
    end

    context "when email or password are incorrect" do
      it "redirects to login_path with an error message" do
        post :process_login, params: { email: "test@example.com", password: "wrong_password" }
        expect(flash[:error]).to eq("Email ou Senha estão errados.")
        expect(response).to redirect_to(login_path)
      end
    end
  end

  describe "POST #logout" do
    let!(:user) { User.create(email: "test@example.com", salt: "$2a$12$9sauXRcV/alggmsRweudU.", password: BCrypt::Password.create("password"), session_key: "valid_session_key") }

    context "when user is logged in" do
      before do
        timestamp = 10.minutes.ago.to_i
        cookies.signed[:user_info] = "valid_session_key_#{timestamp}_test@example.com"
      end

      it "clears the session and redirects to login_path" do
        post :logout
        expect(response).to redirect_to(login_path)
      end
    end

    context "when user is not logged in" do
      before do
        cookies.signed[:user_info] = nil
      end

      it "redirects to login_path" do
        post :logout
        expect(response).to redirect_to(login_path)
      end
    end
  end
end
