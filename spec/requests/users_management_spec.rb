require 'rails_helper'

RSpec.describe "Users (gestão e importação)", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { User.create!(email: "admin_mgmt@unb.br", password: "password123", nome: "Admin", matricula: "0009", perfil: "docente") }

  before { sign_in admin }

  def upload(conteudo, ext, tipo)
    file = Tempfile.new([ "up", ext ])
    file.write(conteudo)
    file.rewind
    Rack::Test::UploadedFile.new(file.path, tipo)
  end

  describe "GET /usuarios" do
    it "lista usuários e registros pendentes (Happy Path)" do
      get "/usuarios"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /users (create)" do
    it "convida um novo usuário e redireciona (Happy Path)" do
      expect {
        post "/users", params: { nome: "Novo", email: "novo_user@unb.br", matricula: "12321", perfil: "discente" }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to("/usuarios")
      expect(flash[:notice]).to match(/cadastrado com sucesso/)
    end

    it "recusa e-mail já em uso (Sad Path)" do
      User.create!(email: "existente@unb.br", password: "password123", nome: "X", matricula: "55501", perfil: "discente")
      post "/users", params: { nome: "Y", email: "existente@unb.br", matricula: "55502", perfil: "discente" }

      expect(response).to redirect_to("/usuarios/novo")
      expect(flash[:alert]).to match(/já está em uso/)
    end

    it "cai no rescue quando a criação falha (Sad Path)" do
      allow(User).to receive(:invite!).and_raise(ActiveRecord::RecordInvalid.new(User.new))

      post "/users", params: { nome: "Falha", email: "falha@unb.br", matricula: "55503", perfil: "discente" }

      expect(response).to redirect_to("/usuarios/novo")
      expect(flash[:alert]).to match(/Erro ao cadastrar/)
    end
  end

  describe "POST /users/register_participants" do
    let(:participantes_json) do
      [
        { "email" => "p1@unb.br", "nome" => "P Um", "matricula" => "10001" },
        { "email" => "p2@unb.br", "nome" => "P Dois", "matricula" => "10002" }
      ].to_json
    end

    it "registra participantes e envia convites (Happy Path)" do
      expect {
        post "/users/register_participants",
          params: { participants_file: upload(participantes_json, ".json", "application/json") }
      }.to change(PendingRegistration, :count).by(2)

      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to match(/Convites enviados/)
    end

    it "ignora participantes já cadastrados (Sad Path)" do
      User.create!(email: "p1@unb.br", password: "password123", nome: "P Um", matricula: "10001", perfil: "discente")
      post "/users/register_participants",
        params: { participants_file: upload(participantes_json, ".json", "application/json") }

      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to match(/já cadastrado, ignorado/)
    end
  end

  describe "POST /users/import (CSV)" do
    let(:csv) do
      <<~CSV
        turma_code,class_code,semester,turma_name,departamento,nome,email,matricula,perfil
        CIC0200,TA,2026.1,Engenharia,CIC,Aluno CSV,aluno_csv@unb.br,30001,discente
      CSV
    end

    it "importa turmas, usuários e matrículas do CSV (Happy Path)" do
      expect {
        post "/users/import", params: { file: upload(csv, ".csv", "text/csv") }
      }.to change(User, :count).by(1).and change(Turma, :count).by(1)

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to match(/importados/)
    end

    it "avisa quando nenhum arquivo é enviado (Sad Path)" do
      post "/users/import"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Nenhum arquivo selecionado")
    end
  end
end
