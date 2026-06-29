require "rails_helper"

RSpec.describe "Passwords", type: :request do
  let!(:user_sem_senha) do
    User.create!(
      nome: "Sem Senha",
      email: "semsenha@camaar.com",
      matricula: "202400010",
      perfil: "Discente",
      primeiro_acesso: true
    )
  end

  let!(:user_com_senha) do
    User.create!(
      nome: "Com Senha",
      email: "comsenha@camaar.com",
      matricula: "202400011",
      perfil: "Discente",
      password: "senha123",
      password_confirmation: "senha123",
      primeiro_acesso: false
    )
  end

  describe "GET /definir_senha" do
    context "com email válido (primeiro_acesso true)" do
      it "retorna 200 e exibe o formulário" do
        get "/definir_senha", params: { email: user_sem_senha.email }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Nova Senha")
        expect(response.body).to include("Confirmar Senha")
        expect(response.body).to include("Salvar")
      end
    end

    context "com email inexistente" do
      it "exibe mensagem de link inválido" do
        get "/definir_senha", params: { email: "naoexiste@camaar.com" }
        expect(response.body).to include("Link de definição de senha inválido ou expirado")
      end
    end

    context "com email de usuário que já tem senha (primeiro_acesso false)" do
      it "exibe mensagem de link inválido" do
        get "/definir_senha", params: { email: user_com_senha.email }
        expect(response.body).to include("Link de definição de senha inválido ou expirado")
      end
    end
  end

  describe "PATCH /definir_senha" do
    context "com senhas válidas e correspondentes" do
      it "define a senha, marca primeiro_acesso false e redireciona para login" do
        patch "/definir_senha", params: {
          email: user_sem_senha.email,
          password: "novaSenha123",
          password_confirmation: "novaSenha123"
        }
        expect(response).to redirect_to(login_path)
        user = user_sem_senha.reload
        expect(user.authenticate("novaSenha123")).to be_truthy
        expect(user.primeiro_acesso).to be(false)
      end
    end

    context "com campos vazios" do
      it "retorna 422, exibe Senha inválida e mantém primeiro_acesso true" do
        patch "/definir_senha", params: {
          email: user_sem_senha.email,
          password: "",
          password_confirmation: ""
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Senha inválida")
        expect(user_sem_senha.reload.primeiro_acesso).to be(true)
      end
    end

    context "com senhas que não correspondem" do
      it "retorna 422, exibe Senha inválida e mantém primeiro_acesso true" do
        patch "/definir_senha", params: {
          email: user_sem_senha.email,
          password: "senhaA123",
          password_confirmation: "senhaB456"
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Senha inválida")
        expect(user_sem_senha.reload.primeiro_acesso).to be(true)
      end
    end

    context "com email inexistente" do
      it "exibe mensagem de link inválido" do
        patch "/definir_senha", params: {
          email: "naoexiste@camaar.com",
          password: "senha123",
          password_confirmation: "senha123"
        }
        expect(response.body).to include("Link de definição de senha inválido ou expirado")
      end
    end
  end
end
