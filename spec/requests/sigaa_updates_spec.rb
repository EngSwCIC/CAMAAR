require 'rails_helper'

RSpec.describe "SigaaUpdates", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { User.create!(email: "admin_sig@unb.br", password: "password123", nome: "Admin", matricula: "0002", perfil: "docente") }

  before { sign_in admin }

  def upload_csv(conteudo)
    file = Tempfile.new([ "sigaa", ".csv" ])
    file.write(conteudo)
    file.rewind
    Rack::Test::UploadedFile.new(file.path, "text/csv")
  end

  describe "GET /sigaa/atualizar" do
    it "renderiza a página de atualização (Happy Path)" do
      get "/sigaa/atualizar"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /sigaa/atualizar" do
    let(:csv_valido) do
      <<~CSV
        turma_code,class_code,semester,turma_name,departamento,nome,email,matricula,perfil
        CIC0105,TA,2026.1,Engenharia,CIC,Ana,ana@unb.br,190001,discente
        CIC0105,TA,2026.1,Engenharia,CIC,Prof,prof@unb.br,830002,docente
      CSV
    end

    it "atualiza a base e cria turmas, usuários e matrículas (Happy Path)" do
      post "/sigaa/atualizar", params: { sigaa_file: upload_csv(csv_valido) }

      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to match(/atualizada com sucesso/)
      expect(Turma.find_by(code: "CIC0105")).to be_present
      expect(User.find_by(email: "ana@unb.br")).to be_present
      expect(Enrollment.count).to eq(2)
    end

    it "rejeita arquivo vazio (Sad Path)" do
      post "/sigaa/atualizar", params: { sigaa_file: upload_csv("") }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Arquivo SIGAA inválido")
    end

    it "rejeita quando nenhum arquivo é enviado (Sad Path)" do
      post "/sigaa/atualizar"
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Arquivo SIGAA inválido")
    end
  end
end
