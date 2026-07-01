require 'rails_helper'

RSpec.describe "Gerenciamento de Senhas", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }

  let(:usuario_sem_senha) do
    Docente.create!(
      nome: "Novo Professor",
      matricula: "doc002",
      email: "novo@unb.br",
      formacao: "Mestrado",
      senha_hash: nil,
      definicao_senha_token: "token_definicao_123"
    )
  end

  let(:usuario_esquecido) do
    Docente.create!(
      nome: "Professor Esquecido",
      matricula: "doc003",
      email: "esquecido@unb.br",
      formacao: "Doutorado",
      senha: "SenhaAntiga123",
      senha_confirmation: "SenhaAntiga123",
      redefinicao_senha_token: "token_redefinicao_456"
    )
  end

  describe "Cadastrar senha (Primeiro Acesso)" do
    it "GET /definir_senha/:token acessa a tela de cadastro" do
      get edit_definicao_senha_path(token: usuario_sem_senha.definicao_senha_token)
      expect(response).to have_http_status(:ok)
    end

    it "GET /definir_senha/:token redireciona para root se o token for inválido (sad path)" do
      get edit_definicao_senha_path(token: "token_inexistente")
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link de definição de senha inválido.")
    end

    it "PATCH /definir_senha/:token define a senha e redireciona para login" do
      patch definicao_senha_path(token: usuario_sem_senha.definicao_senha_token), params: {
        senha: "NovaSenhaSegura123",
        senha_confirmation: "NovaSenhaSegura123"
      }
      usuario_sem_senha.reload
      expect(usuario_sem_senha.senha_definida?).to be true
      expect(response).to redirect_to(root_path)
    end

    it "PATCH /definir_senha/:token redireciona para root se o token for inválido (sad path)" do
      patch definicao_senha_path(token: "token_inexistente"), params: {
        senha: "NovaSenhaSegura123",
        senha_confirmation: "NovaSenhaSegura123"
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link de definição de senha inválido.")
    end

    it "PATCH /definir_senha/:token falha quando senhas não conferem (sad path)" do
      patch definicao_senha_path(token: usuario_sem_senha.definicao_senha_token), params: {
        senha: "NovaSenha123",
        senha_confirmation: "SenhaDiferente456"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to include("confirmação não confere")
    end

    it "PATCH /definir_senha/:token falha quando senha menor que 6 caracteres (sad path)" do
      patch definicao_senha_path(token: usuario_sem_senha.definicao_senha_token), params: {
        senha: "abc",
        senha_confirmation: "abc"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to include("senha inválida")
    end

    it "PATCH /definir_senha/:token falha se o modelo falhar ao salvar no banco (sad path)" do
      allow_any_instance_of(Usuario).to receive(:save).and_return(false)
      patch definicao_senha_path(token: usuario_sem_senha.definicao_senha_token), params: {
        senha: "NovaSenhaSegura123",
        senha_confirmation: "NovaSenhaSegura123"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to eq("Flha na definição de senha: senha inválida").or eq("Falha na definição de senha: senha inválida")
    end
  end

  describe "Redefinir senha" do
    it "GET /redefinir_senha exibe o formulário de solicitação" do
      get redefinir_senha_path
      expect(response).to have_http_status(:ok)
    end

    it "POST /redefinir_senha redireciona com alerta quando email em branco" do
      post redefinir_senha_path, params: { email: "" }
      expect(response).to redirect_to(redefinir_senha_path)
      expect(flash[:alert]).to include("informe seu email")
    end

    it "POST /redefinir_senha redireciona com alerta quando usuário não encontrado" do
      post redefinir_senha_path, params: { email: "naoexiste@unb.br" }
      expect(response).to redirect_to(redefinir_senha_path)
      expect(flash[:alert]).to include("usuário não encontrado")
    end

    it "POST /redefinir_senha solicita a troca e envia email" do
      post redefinir_senha_path, params: { email: usuario_esquecido.email }
      usuario_esquecido.reload
      expect(usuario_esquecido.redefinicao_senha_token).not_to be_nil
      expect(response).to redirect_to(root_path)
    end

    it "GET /redefinir_senha/:token redireciona para root se o token for inválido (sad path)" do
      get edit_redefinicao_senha_path(token: "token_inexistente")
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link de redefinição de senha inválido.")
    end

    it "PATCH /redefinir_senha/:token salva a nova senha e redireciona" do
      patch redefinicao_senha_path(token: usuario_esquecido.redefinicao_senha_token), params: {
        senha: "SenhaTotalmenteNova1",
        senha_confirmation: "SenhaTotalmenteNova1"
      }
      expect(response).to redirect_to(root_path)
    end

    it "PATCH /redefinir_senha/:token redireciona para root se o token for inválido (sad path)" do
      patch redefinicao_senha_path(token: "token_inexistente"), params: {
        senha: "SenhaTotalmenteNova1",
        senha_confirmation: "SenhaTotalmenteNova1"
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Link de redefinição de senha inválido.")
    end

    it "PATCH /redefinir_senha/:token falha quando senhas não conferem (sad path)" do
      patch redefinicao_senha_path(token: usuario_esquecido.redefinicao_senha_token), params: {
        senha: "SenhaNova123",
        senha_confirmation: "SenhaDiferente456"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to include("confirmação não confere")
    end

    it "PATCH /redefinir_senha/:token falha quando senha menor que 6 caracteres (sad path)" do
      patch redefinicao_senha_path(token: usuario_esquecido.redefinicao_senha_token), params: {
        senha: "abc",
        senha_confirmation: "abc"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to include("senha inválida")
    end

    it "PATCH /redefinir_senha/:token falha se o modelo falhar ao salvar no banco (sad path)" do
      allow_any_instance_of(Usuario).to receive(:save).and_return(false)
      patch redefinicao_senha_path(token: usuario_esquecido.redefinicao_senha_token), params: {
        senha: "SenhaTotalmenteNova1",
        senha_confirmation: "SenhaTotalmenteNova1"
      }
      expect(response).to have_http_status(:unprocessable_content)
      expect(flash.now[:alert]).to eq("Falha na redefinição de senha: senha inválida")
    end
  end
end
