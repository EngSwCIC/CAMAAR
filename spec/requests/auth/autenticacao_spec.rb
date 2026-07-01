# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Autenticacao", type: :request do
  let(:usuario_mock) do
    double(
      "Usuario",
      id: 42,
      email: "rafael@email.com",
      matricula: "123456789",
      ativo?: true
    )
  end

  describe "POST /login (Happy Path)" do
    it "autentica com sucesso usando MATRÍCULA e redireciona para avaliacoes" do
      allow(Usuario).to receive(:find_by).with(matricula: "123456789").and_return(usuario_mock)
      allow(usuario_mock).to receive(:authenticate_senha).with("senha_correta").and_return(true)
      post login_path, params: { identificador: "123456789", senha: "senha_correta" }

      expect(response).to redirect_to(avaliacoes_path)
      expect(flash[:success]).to eq("Login realizado com sucesso! Seja bem-vindo.")
    end

    it "autentica com sucesso usando E-MAIL e redireciona para avaliacoes" do
      allow(Usuario).to receive(:find_by).with(email: "rafael@email.com").and_return(usuario_mock)
      allow(usuario_mock).to receive(:authenticate_senha).with("senha_correta").and_return(true)

      post login_path, params: { identificador: "rafael@email.com", senha: "senha_correta" }

      expect(response).to redirect_to(avaliacoes_path)
      expect(flash[:success]).to eq("Login realizado com sucesso! Seja bem-vindo.")
    end
  end

  describe "POST /login (Sad Path)" do
    it "falha se o usuário não for encontrado no banco" do
      allow(Usuario).to receive(:find_by).with(matricula: "000000").and_return(nil)

      post login_path, params: { identificador: "000000", senha: "qualquer_senha" }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Matrícula ou e-mail inválido.")
    end

    it "falha se a conta do usuário não estiver ativa" do
      usuario_inativo = double("UsuarioInativo", ativo?: false)
      allow(Usuario).to receive(:find_by).with(matricula: "123").and_return(usuario_inativo)

      post login_path, params: { identificador: "123", senha: "uma_senha" }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Esta conta ainda não foi ativada. Por favor, realize o Primeiro Acesso.")
    end

    it "falha se a senha estiver incorreta" do
      allow(Usuario).to receive(:find_by).with(matricula: "123456789").and_return(usuario_mock)
      allow(usuario_mock).to receive(:authenticate_senha).with("senha_errada").and_return(false)

      post login_path, params: { identificador: "123456789", senha: "senha_errada" }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("Senha incorreta.")
    end
  end
end
