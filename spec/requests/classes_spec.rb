require 'rails_helper'

RSpec.describe "Classes", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:admin) { User.create!(email: "admin_cic@unb.br", password: "password123", nome: "Admin", matricula: "0001", perfil: "docente", departamento: "CIC") }
  let!(:turma_cic) { Turma.create!(code: "CIC0001", class_code: "TA", semester: "2026.1", name: "ES", departamento: "CIC") }
  let!(:turma_mat) { Turma.create!(code: "MAT0001", class_code: "UA", semester: "2026.1", name: "Cálculo", departamento: "MAT") }

  before { sign_in admin }

  describe "GET /classes" do
    it "lista apenas as turmas do departamento do admin (Happy Path)" do
      get "/classes"
      expect(response).to have_http_status(:success)
      expect(response.body).to include("CIC0001")
      expect(response.body).not_to include("MAT0001")
    end
  end

  describe "GET /classes/:code" do
    it "mostra a turma do próprio departamento (Happy Path)" do
      get "/classes/CIC0001"
      expect(response).to have_http_status(:success)
    end

    it "bloqueia turma de outro departamento (Sad Path)" do
      get "/classes/MAT0001"
      expect(response).to redirect_to(classes_path)
      expect(flash[:alert]).to match(/Acesso negado/)
    end
  end

  describe "GET /classes/:code/edit" do
    it "permite editar turma do departamento (Happy Path)" do
      get "/classes/CIC0001/edit"
      expect(response).to have_http_status(:success)
    end

    it "bloqueia edição de turma de outro departamento (Sad Path)" do
      get "/classes/MAT0001/edit"
      expect(response).to redirect_to(classes_path)
    end
  end

  describe "PATCH /classes/:code" do
    it "atualiza o professor da turma do departamento (Happy Path)" do
      patch "/classes/CIC0001", params: { professor: "Dra. Fulana" }
      expect(response).to redirect_to(classes_path)
      expect(flash[:notice]).to match(/atualizada com sucesso/)
    end

    it "bloqueia atualização de turma de outro departamento (Sad Path)" do
      patch "/classes/MAT0001", params: { professor: "X" }
      expect(response).to redirect_to(classes_path)
      expect(flash[:alert]).to match(/Acesso negado/)
    end
  end
end
