# frozen_string_literal: true

require "rails_helper"

RSpec.describe BrevoEmailable do
  let(:mailer_class) { Class.new { include BrevoEmailable } }
  let(:mailer) { mailer_class.new }

  it "monta headers e request HTTP para a Brevo" do
    payload = { "subject" => "Teste" }

    request = mailer.brevo_request(payload, "api-key")

    expect(mailer.brevo_headers("api-key")).to include(
      "Accept" => "application/json",
      "api-key" => "api-key",
      "Content-Type" => "application/json"
    )
    expect(request.path).to eq("/v3/smtp/email")
    expect(request.body).to eq(payload.to_json)
  end

  it "configura o cliente HTTP com SSL" do
    http = mailer.brevo_http

    expect(http.address).to eq("api.brevo.com")
    expect(http.port).to eq(443)
    expect(http.use_ssl?).to be(true)
  end

  it "envia payload quando a API responde com sucesso" do
    response = Net::HTTPOK.new("1.1", "200", "OK")
    http = instance_double(Net::HTTP)

    allow(mailer).to receive(:brevo_api_key).and_return("api-key")
    allow(mailer).to receive(:brevo_http).and_return(http)
    allow(http).to receive(:request).and_return(response)

    expect(mailer.chamar_api_brevo({ "subject" => "Teste" }, contexto: "Cadastro"))
      .to be(true)
  end

  it "retorna falso quando a API key não está configurada" do
    allow(mailer).to receive(:brevo_api_key).and_return(nil)

    expect(mailer.chamar_api_brevo({}, contexto: "Cadastro")).to be(false)
  end

  it "retorna falso quando a API responde erro" do
    response = Net::HTTPBadRequest.new("1.1", "400", "Bad Request")
    allow(response).to receive(:body).and_return("payload inválido")

    expect(mailer.brevo_response_sucesso?(response, "Cadastro")).to be(false)
  end

  it "retorna falso quando a chamada HTTP levanta exceção" do
    http = instance_double(Net::HTTP)

    allow(mailer).to receive(:brevo_api_key).and_return("api-key")
    allow(mailer).to receive(:brevo_http).and_return(http)
    allow(http).to receive(:request).and_raise(StandardError, "timeout")

    expect(mailer.chamar_api_brevo({}, contexto: "Cadastro")).to be(false)
  end

  it "monta o e-mail de cadastro" do
    expect(mailer).to receive(:chamar_api_brevo) do |payload, contexto:|
      expect(contexto).to eq("Cadastro")
      expect(payload["to"]).to eq([ { "email" => "aluno@example.com" } ])
      expect(payload["subject"]).to eq("Link de cadastro do CAMAAR")
      expect(payload["htmlContent"]).to include("token-cadastro")
      true
    end

    expect(mailer.enviar_email_cadastro("aluno@example.com", "token-cadastro")).to be(true)
  end

  it "monta o e-mail de redefinição de senha" do
    expect(mailer).to receive(:chamar_api_brevo) do |payload, contexto:|
      expect(contexto).to eq("Redefinição de senha")
      expect(payload["subject"]).to eq("Recuperação de Senha — CAMAAR")
      expect(payload["htmlContent"]).to include("token-redefinicao")
      true
    end

    expect(mailer.enviar_email_redefinicao("aluno@example.com", "token-redefinicao")).to be(true)
  end

  it "monta o e-mail de convite administrativo" do
    expect(mailer).to receive(:chamar_api_brevo) do |payload, contexto:|
      expect(contexto).to eq("Convite do Administrador")
      expect(payload["subject"]).to include("Coordenador")
      expect(payload["htmlContent"]).to include("token-convite")
      true
    end

    expect(mailer.enviar_email_convite_admin("aluno@example.com", "token-convite", "Coordenador")).to be(true)
  end

  it "prioriza a API key da variável de ambiente" do
    allow(ENV).to receive(:[]).with("BREVO_API_KEY").and_return("env-key")

    expect(mailer.send(:brevo_api_key)).to eq("env-key")
  end

  it "retorna nil quando credenciais não podem ser lidas" do
    allow(ENV).to receive(:[]).with("BREVO_API_KEY").and_return(nil)
    allow(Rails.application.credentials)
      .to receive(:dig)
      .and_raise(ActiveSupport::MessageVerifier::InvalidSignature)

    expect(mailer.send(:brevo_api_key)).to be_nil
  end
end
