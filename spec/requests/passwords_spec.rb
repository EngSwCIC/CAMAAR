require 'rails_helper'

RSpec.describe "Passwords", type: :request do
  describe "GET /forgot" do
    it "renders the forgot password page" do
      get forgot_password_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /forgot" do
    it "requires an email" do
      post forgot_password_path, params: { email: "" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Preencha o campo de e-mail")
    end

    it "requires a valid email format" do
      post forgot_password_path, params: { email: "invalid_email" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("E-mail inválido")
    end

    it "sends an email if valid" do
      user = Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true)
      post forgot_password_path, params: { email: user.email }
      expect(response).to redirect_to(login_path)
      user.reload
      expect(user.reset_token).to be_present
    end
  end

  describe "GET /reset/:token" do
    it "renders the reset page if token is valid" do
      user = Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true)
      user.generate_reset_token!
      get reset_password_path(token: user.reset_token)
      expect(response).to have_http_status(:success)
    end

    it "renders error if token is expired" do
      user = Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true)
      user.generate_reset_token!
      user.update_column(:reset_token_sent_at, 25.hours.ago)
      
      get reset_password_path(token: user.reset_token)
      # Depende do fix no controller, esperamos que renderize erro ou redirecione
      expect(response.body).to include("Link expirado")
    end
  end

  describe "POST /reset/:token" do
    let(:user) { Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true) }

    before do
      user.generate_reset_token!
    end

    it "fails if token is expired" do
      user.update_column(:reset_token_sent_at, 25.hours.ago)
      post reset_password_path(token: user.reset_token), params: { password: "NovaSenha1!", password_confirmation: "NovaSenha1!" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Link expirado")
    end

    it "fails if passwords don't match" do
      post reset_password_path(token: user.reset_token), params: { password: "novasenha123", password_confirmation: "novasenha321" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("As senhas não coincidem")
    end

    it "fails if new password equals old password" do
      post reset_password_path(token: user.reset_token), params: { password: "senha", password_confirmation: "senha" }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("A nova senha não pode ser igual à senha anterior")
    end

    it "fails if password is blank" do
      post reset_password_path(token: user.reset_token), params: { password: "", password_confirmation: "" }
      expect(response).to have_http_status(:success) # rendered reset template
      expect(response.body).to include("Preencha todos os campos obrigatórios")
    end

    it "resets password with valid data" do
      post reset_password_path(token: user.reset_token), params: { password: "novasenha123", password_confirmation: "novasenha123" }
      expect(response).to redirect_to(login_path)
      user.reload
      expect(user.authenticate("novasenha123")).to be_truthy
    end
  end
end
