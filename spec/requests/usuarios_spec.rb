require "rails_helper"

RSpec.describe "Cadastro de usuários", type: :request do
  let(:dados_validos) do
    {
      usuario: {
        nome: "Maria Silva",
        email: "maria@example.com",
        password: "Senha123",
        password_confirmation: "Senha123"
      }
    }
  end

  describe "GET /signup" do
    it "exibe o formulário de cadastro" do
      get signup_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("CADASTRO")
      expect(response.body).to include("signup-container", "signup-left")
    end
  end

  describe "POST /signup" do
    it "cadastra o usuário e redireciona para o login" do
      expect {
        post signup_path, params: dados_validos
      }.to change(Usuario, :count).by(1)

      expect(response).to redirect_to(login_path)
      expect(Usuario.last).to be_estudante
    end

    it "não cadastra email duplicado" do
      Usuario.create!(dados_validos[:usuario])

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Email")
    end

    it "não cadastra email inválido" do
      dados_validos[:usuario][:email] = "email-invalido"

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Email é inválido")
    end

    it "não cadastra senha sem a complexidade mínima" do
      dados_validos[:usuario][:password] = "fraca"
      dados_validos[:usuario][:password_confirmation] = "fraca"

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("incluindo letras e números")
    end

    it "não cadastra quando a confirmação diverge" do
      dados_validos[:usuario][:password_confirmation] = "Outra123"

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Password confirmation")
    end

    it "não cadastra sem confirmação de senha" do
      dados_validos[:usuario].delete(:password_confirmation)

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("é obrigatória")
    end

    it "não cadastra senha maior que 72 bytes" do
      senha = "Senha123" + ("a" * 65)
      dados_validos[:usuario][:password] = senha
      dados_validos[:usuario][:password_confirmation] = senha

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "não cadastra sem nome" do
      dados_validos[:usuario][:nome] = ""

      expect {
        post signup_path, params: dados_validos
      }.not_to change(Usuario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Nome é obrigatório")
    end
  end
end
