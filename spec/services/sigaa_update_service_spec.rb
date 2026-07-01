require "rails_helper"

RSpec.describe SigaaSyncService do
  let(:user) { User.create!(email: 'test@unb.br', matricula: '9999', role: 'admin', password: 'password123', password_confirmation: 'password123') }

  before do
    allow(SigaaApi).to receive(:fetch_data)
      .and_return('[{"id":1}]')

    allow(SigaaImporter).to receive(:import_classes)
      .and_return(success: true)

    allow(SigaaImporter).to receive(:import_members)
      .and_return(success: true)
  end

  it "executa atualização com sucesso" do
    result = described_class.new(user).call

    expect(result[:success]).to be true
    expect(result[:message]).to eq("Atualização concluída com sucesso")
  end

  it "bloqueia usuário não admin" do
    user = double("User", admin?: false)

    result = described_class.new(user).call

    expect(result[:success]).to be false
    expect(result[:message]).to eq("Acesso negado")
  end

  it "detecta atualização duplicada" do
    allow(SyncLock).to receive(:active?).and_return(true)

    result = described_class.new(user).call

    expect(result[:success]).to be false
    expect(result[:message]).to eq("Já existe uma atualização em andamento")
  end

  it "detecta dados vazios" do
    allow(SigaaApi).to receive(:fetch_data).and_return("[]")

    result = described_class.new(user).call

    expect(result[:success]).to be false
    expect(result[:message]).to eq("SIGAA não retornou dados")
  end

  it "detecta falha de conexão" do
    allow(SigaaApi).to receive(:fetch_data).and_raise("Falha de conexão com o SIGAA")

    result = described_class.new(user).call

    expect(result[:success]).to be false
    expect(result[:message]).to include("Falha de conexão")
  end
end