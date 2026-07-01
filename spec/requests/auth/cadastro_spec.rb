# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Fluxo de Cadastro (Primeiro Acesso)", type: :request do
  let!(:usuario_institucional) do
    Usuario.create!(
      matricula: "26100001",
      nome: "Rafael Sapienza",
      email: "rafael@unb.br",
      status: :pendente,
      senha: "vazia_inicialmente"
    )
  end
  describe "POST /cadastro" do
    it "rejeita se o formato do e-mail for inválido" do
      post cadastro_path, params: { matricula: "26100001", email: "email_invalido" }

      expect(response).to redirect_to(cadastro_path)
      expect(flash[:error]).to eq("Por favor, insira um formato de e-mail válido.")
    end

    it "rejeita se a matrícula não existir no sistema" do
      post cadastro_path, params: { matricula: "99999999", email: "rafael@unb.br" }

      expect(response).to redirect_to(cadastro_path)
      expect(flash[:error]).to eq("Matrícula não encontrada no sistema institucional.")
    end

    it "rejeita se o e-mail não bater com o e-mail cadastrado na matrícula" do
      post cadastro_path, params: { matricula: "26100001", email: "outro_email@unb.br" }

      expect(response).to redirect_to(cadastro_path)
      expect(flash[:error]).to eq("O e-mail informado não corresponde ao e-mail institucional desta matrícula.")
    end

    it "rejeita se a matrícula já possuir um cadastro ativo" do
      usuario_institucional.update!(status: :ativo)

      post cadastro_path, params: { matricula: "26100001", email: "rafael@unb.br" }

      expect(response).to redirect_to(cadastro_path)
      expect(flash[:error]).to eq("Esta matrícula já possui um cadastro ativo. Caso tenha esquecido sua senha, utilize a redefinição.")
    end

    it "Gera token e redireciona com sucesso se a Brevo responder que enviou o e-mail" do
      allow_any_instance_of(AuthController)
        .to receive(:enviar_email_cadastro)
        .and_return(true)
      expect {
        post cadastro_path, params: { matricula: "26100001", email: "rafael@unb.br" }
      }.to change(Token, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to include("E-mail enviado com sucesso!")
    end

    it "Redireciona com erro técnico se a chamada à API da Brevo falhar por qualquer motivo" do
      allow_any_instance_of(AuthController)
        .to receive(:enviar_email_cadastro)
        .and_return(false)

      post cadastro_path, params: { matricula: "26100001", email: "rafael@unb.br" }

      expect(response).to redirect_to(cadastro_path)
      expect(flash[:error]).to eq("Houve um erro técnico ao tentar enviar o e-mail. Tente novamente mais tarde.")
    end
  end
  describe "POST /cadastro/confirmar" do
    let!(:token_valido) do
      usuario_institucional.tokens.create!(
        value: "token_secreto_123",
        tipo: "cadastro",
        expires_at: 10.minutes.from_now
      )
    end

    it "rejeita se a senha tiver menos de 8 caracteres" do
      post confirmar_cadastro_path, params: { token: "token_secreto_123", senha: "123", senha_confirmacao: "123" }

      expect(response).to redirect_to(confirmar_cadastro_path(token: "token_secreto_123"))
      expect(flash[:error]).to eq("A senha deve conter pelo menos 8 caracteres.")
    end

    it "rejeita se as senhas digitadas não coincidirem" do
      post confirmar_cadastro_path, params: { token: "token_secreto_123", senha: "senha123", senha_confirmacao: "outrasenha" }

      expect(response).to redirect_to(confirmar_cadastro_path(token: "token_secreto_123"))
      expect(flash[:error]).to eq("As senhas não coincidem. Digite novamente.")
    end

    it "rejeita se o token passado for inválido ou não existir no banco" do
      post confirmar_cadastro_path, params: { token: "token_inexistente", senha: "senha123", senha_confirmacao: "senha123" }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("O link de confirmação é inválido, expirou ou não corresponde a esta operação.")
    end

    it "rejeita se o token estiver correto mas já estiver expirado" do
      token_valido.update!(expires_at: 5.minutes.ago)

      post confirmar_cadastro_path, params: { token: "token_secreto_123", senha: "senha123", senha_confirmacao: "senha123" }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq("O link de confirmação é inválido, expirou ou não corresponde a esta operação.")
    end

    it "salva a nova senha, ativa o cadastro e destrói o token usado" do
      expect {
        post confirmar_cadastro_path, params: { token: "token_secreto_123", senha: "senha123", senha_confirmacao: "senha123" }
      }.to change(Token, :count).by(-1)
      usuario_institucional.reload
      expect(usuario_institucional).to be_ativo

      expect(response).to redirect_to(root_path)
      expect(flash[:success]).to eq("Cadastro concluído com sucesso! Faça seu login.")
    end
  end
end
