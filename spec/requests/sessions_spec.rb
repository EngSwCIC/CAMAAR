require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "GET /login" do
    it "renders the login page" do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("Entrar")
    end

    it "redirects already logged in users" do
      user = Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true)
      post login_path, params: { email: user.email, password: "senha" }
      get login_path
      expect(response).to redirect_to(admin_dashboard_path)
    end
  end

  describe "POST /login" do
    let(:user) { Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true) }
    let(:discente) { Usuario.create!(nome: "Discente", email: "discente@unb.br", perfil: "discente", password: "senha", ativo: true) }

    it "logs in with valid credentials and redirects admin" do
      post login_path, params: { email: user.email, password: "senha" }
      expect(session[:usuario_id]).to eq(user.id)
      expect(response).to redirect_to(admin_dashboard_path)
      follow_redirect!
      expect(response.body).to include("Bem-vindo, #{user.nome}!")
    end

    it "logs in with valid credentials and redirects discente" do
      post login_path, params: { email: discente.email, password: "senha" }
      expect(session[:usuario_id]).to eq(discente.id)
      expect(response).to redirect_to(avaliacoes_path)
    end

    it "fails with empty credentials" do
      post login_path, params: { email: "", password: "" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Preencha todos os campos obrigatórios")
    end

    it "fails with invalid email format" do
      post login_path, params: { email: "invalid", password: "senha" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("E-mail inválido")
    end

    it "fails with invalid credentials" do
      post login_path, params: { email: user.email, password: "wrong_password" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("E-mail ou senha inválidos")
    end

    it "fails with invalid credentials (matricula)" do
      post login_path, params: { email: "123456789", password: "wrong_password" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Matrícula ou senha inválidos")
    end

    it "fails with unexisting matricula" do
      post login_path, params: { email: "123456789", password: "senha" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Matrícula ou senha inválidos")
    end

    it "fails with unexisting email" do
      post login_path, params: { email: "nonexistent@unb.br", password: "senha" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("E-mail ou senha inválidos")
    end

    it "handles pending setup user" do
      pending_user = Usuario.create!(nome: "Pending", email: "pending@unb.br", perfil: "discente", password: "senha", ativo: true)
      pending_user.generate_setup_token!
      post login_path, params: { email: pending_user.email, password: "senha" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Cadastro pendente")
    end

    it "handles inactive user" do
      inactive_user = Usuario.create!(nome: "Inactive", email: "inactive@unb.br", perfil: "discente", password: "senha", ativo: false)
      post login_path, params: { email: inactive_user.email, password: "senha" }
      expect(session[:usuario_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Usuário inativo")
    end
  end

  describe "GET /login when already logged in as discente" do
    it "redirects to avaliacoes_path" do
      discente = Usuario.create!(nome: "Discente", email: "discente@unb.br", perfil: "discente", password: "senha", ativo: true)
      post login_path, params: { email: discente.email, password: "senha" }
      get login_path
      expect(response).to redirect_to(avaliacoes_path)
    end
  end

  describe "DELETE /logout" do
    it "clears the session and redirects to login" do
      user = Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true)
      post login_path, params: { email: user.email, password: "senha" }
      expect(session[:usuario_id]).to eq(user.id)

      get logout_path
      expect(session[:usuario_id]).to be_nil
      expect(response).to redirect_to(login_path)
      follow_redirect!
      expect(response.body).to include("Você saiu do sistema com sucesso.")
    end
  end
end
