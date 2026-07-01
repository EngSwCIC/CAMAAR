require 'rails_helper'

RSpec.describe PasswordSetsController, type: :controller do
  let(:user) do 
    User.create!(
      email: 'user@test.com', 
      matricula: '123', 
      password: 'password', 
      password_confirmation: 'password', 
      role: 'discente', 
      invitation_token: 'valid_token', 
      invitation_sent_at: Time.current
    ) 
  end

  describe "GET #new" do
    it "renders new if token is valid" do
      get :new, params: { token: user.invitation_token }
      expect(response).to have_http_status(:success)
    end

    it "redirects to login if token is invalid" do
      get :new, params: { token: 'invalid' }
      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq("Link inválido.")
    end

    it "redirects if token is expired" do
      user.update!(invitation_sent_at: 1.year.ago)
      get :new, params: { token: user.invitation_token }
      expect(response).to redirect_to(login_path)
      expect(flash[:alert]).to eq("Este link expirou. Solicite um novo cadastro.")
    end
  end

  describe "PATCH #update" do
    it "updates password successfully" do
      patch :update, params: { token: user.invitation_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to redirect_to(home_path)
      expect(flash[:notice]).to eq("Cadastro efetivado com sucesso!")
      expect(user.reload.invitation_token).to be_nil
    end

    it "fails if token is expired on update" do
      user.update!(invitation_sent_at: 1.year.ago)
      patch :update, params: { token: user.invitation_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to redirect_to(login_path)
    end

    it "fails if passwords do not match" do
      patch :update, params: { token: user.invitation_token, password: 'new_password123', password_confirmation: 'wrong' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("As senhas não coincidem")
    end

    it "fails if password is too short" do
      patch :update, params: { token: user.invitation_token, password: 'short', password_confirmation: 'short' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("A senha deve ter no mínimo 8 caracteres")
    end

    it "fails if fields are blank" do
      patch :update, params: { token: user.invitation_token, password: '', password_confirmation: '' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Preencha todos os campos obrigatórios")
    end

    it "fails to save if user model validation fails" do
      allow_any_instance_of(User).to receive(:update) do |user, args|
        user.errors.add(:base, "Erro no banco de dados")
        false
      end

      patch :update, params: { token: user.invitation_token, password: 'new_password123', password_confirmation: 'new_password123' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Erro no banco de dados")
    end
  end
end
