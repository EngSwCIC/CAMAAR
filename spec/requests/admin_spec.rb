require 'rails_helper'

RSpec.describe "Admins", type: :request do
  let(:admin_user) do
    Usuario.create!(
      nome: "Admin",
      email: "admin@unb.br",
      perfil: "administrador",
      password: "123",
      ativo: true
    )
  end

  before do
    post login_path, params: { email: admin_user.email, password: "123" }
  end

  describe "GET /admin/dashboard" do
    it "returns http success" do
      get admin_dashboard_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/turmas" do
    it "returns http success" do
      get admin_turmas_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/desempenho_semestral" do
    it "returns http success" do
      get admin_desempenho_semestral_path
      expect(response).to have_http_status(:success)
    end
  end

  # --- INÍCIO DOS TESTES DA ISSUE #106 (ESTADO RED) ---
  describe "Sistema de gerenciamento por departamento (Issue #106)" do
    let(:departamento_admin) { Departamento.create!(nome: "Dep Admin") }
    let(:departamento_outro) { Departamento.create!(nome: "Outro Dep") }
    let(:disciplina) { Disciplina.create!(nome: "Disc", codigo: "D1") }

    before do
      admin_user.update!(departamento: departamento_admin)
    end

    context "Visualização de turmas" do
      it "lista apenas as turmas pertencentes ao departamento do administrador" do
        turma_admin = Turma.create!(codigo_turma: "T1", semestre: "2024.1", departamento: departamento_admin, disciplina: disciplina)
        turma_outra = Turma.create!(codigo_turma: "T2", semestre: "2024.1", departamento: departamento_outro, disciplina: disciplina)

        get admin_turmas_path

        expect(response.body).to include("T1")
        expect(response.body).not_to include("T2")
      end

      it "exibe uma lista vazia e uma mensagem de aviso caso o departamento não tenha turmas" do
        get admin_turmas_path

        expect(response.body).to include("Nenhuma turma encontrada para o seu departamento neste semestre")
      end
    end

    context "Segurança e Isolamento" do
      it "bloqueia o acesso direto à URL de uma turma de outro departamento e redireciona com erro" do
        turma_outra = Turma.create!(codigo_turma: "T2", semestre: "2024.1", departamento: departamento_outro, disciplina: disciplina)

        get admin_turma_avaliacoes_path(turma_outra)

        expect(response).to redirect_to(admin_turmas_path)
        follow_redirect!
        expect(response.body).to include("Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento.")
      end
    end
  end
end
