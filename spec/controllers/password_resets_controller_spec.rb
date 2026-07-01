require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let(:user) do 
    User.create!(
      email: 'user@test.com', 
      matricula: '123', 
      password: 'password', 
      password_confirmation: 'password', 
      role: 'discente'
    ) 
  end

  describe "GET #new" do
    it "renders new" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "generates reset token and sends email if user exists" do
      expect_any_instance_of(User).to receive(:generate_reset_token!).and_call_original
      mailer_mock = double("mailer")
      expect(UserMailer).to receive(:reset_password).with(user).and_return(mailer_mock)
      expect(mailer_mock).to receive(:deliver_later)

      post :create, params: { login: user.email }
      expect(response).to redirect_to(login_path)
      expect(flash[:success]).to be_present
    end

    it "redirects without error if user does not exist" do
      post :create, params: { login: 'inexistente@test.com' }
      expect(response).to redirect_to(login_path)
      expect(flash[:success]).to be_present
    end
  end

  describe "GET #edit" do
    before { user.generate_reset_token! }

    it "renders edit if token is valid" do
      get :edit, params: { token: user.reset_token }
      expect(response).to have_http_status(:success)
    end

    it "redirects if token is invalid" do
      get :edit, params: { token: 'invalid' }
      expect(response).to redirect_to(login_path)
    end

    it "redirects if token is expired" do
      user.update!(reset_sent_at: 1.year.ago)
      get :edit, params: { token: user.reset_token }
      expect(response).to redirect_to(login_path)
    end
  end

  describe "PATCH #update" do
    before { user.generate_reset_token! }

    it "updates password successfully" do
      patch :update, params: { token: user.reset_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to redirect_to(home_path)
      expect(user.reload.reset_token).to be_nil
    end

    it "fails if fields are missing" do
      patch :update, params: { token: user.reset_token, password: '', password_confirmation: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Preencha todos os campos obrigatórios")
    end

    it "fails if passwords do not match" do
      patch :update, params: { token: user.reset_token, password: 'new_password123', password_confirmation: 'wrong' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("As senhas não coincidem")
    end

    it "fails if password is short" do
      patch :update, params: { token: user.reset_token, password: 'short', password_confirmation: 'short' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("A senha deve ter no mínimo 8 caracteres")
    end

    it "fails if model validation fails" do
      allow_any_instance_of(User).to receive(:update) do |user, args|
        user.errors.add(:base, "Erro interno")
        false
      end

      patch :update, params: { token: user.reset_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "fails if token is expired" do
      user.update!(reset_sent_at: 1.year.ago)
      patch :update, params: { token: user.reset_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to redirect_to(login_path)
    end
  end
end
