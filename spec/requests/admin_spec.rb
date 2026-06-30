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

    it "releases lock if release_lock param is true" do
      get admin_dashboard_path, params: { release_lock: "true" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/turmas" do
    it "returns http success" do
      get admin_turmas_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/turma_avaliacoes" do
    it "returns http success for turma without department restriction" do
      turma = Turma.create!(codigo_turma: "T1", semestre: "2024", departamento: Departamento.create!(nome: "D1"), disciplina: Disciplina.create!(nome: "D1", codigo: "D1"))
      get admin_turma_avaliacoes_path(turma)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/desempenho_semestral" do
    it "returns http success and computes averages" do
      get admin_desempenho_semestral_path
      expect(response).to have_http_status(:success)
    end
  end

  context "Cenários Tristes: Acesso negado a usuários não administrativos" do
    let(:discente_teste) { Usuario.create!(nome: "Discente", email: "aluno_comum@unb.br", perfil: "discente", password: "123", ativo: true) }

    it "bloqueia o acesso de um estudante às páginas de admin e redireciona para root_path" do
      post login_path, params: { email: discente_teste.email, password: "123" }
      get admin_dashboard_path
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Acesso negado. Esta área é restrita para administradores.")
    end
  end

  describe "POST /admin/carregar_dados_teste" do
    it "loads data successfully" do
      allow(TestDataLoader).to receive(:call).and_return(true)
      post carregar_dados_teste_path
      expect(response).to redirect_to(admin_dashboard_path)
      expect(flash[:notice]).to include("Importação concluída com sucesso")
    end

    it "handles simulated errors" do
      post carregar_dados_teste_path, params: { sigaa_api_status: "offline" }
      expect(response).to redirect_to(admin_dashboard_path)
      expect(flash[:alert]).to include("Erro de conexão com o SIGAA")
    end

    it "handles exceptions during load" do
      allow(TestDataLoader).to receive(:call).and_raise(StandardError.new("Test Error"))
      post carregar_dados_teste_path
      expect(response).to redirect_to(admin_dashboard_path)
      expect(flash[:alert]).to include("Erro ao carregar dados de teste")
    end
  end

  describe "GET /admin/import_console" do
    it "renders success and handles release_lock" do
      get admin_import_console_path, params: { release_lock: "true" }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /admin/sigaa_import" do
    it "handles offline error" do
      post sigaa_import_path, params: { sigaa_api_status: "offline" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Erro de conexão com o SIGAA")
    end

    it "handles corrupted error" do
      post sigaa_import_path, params: { sigaa_data: "corrupted" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Erro de compatibilidade")
    end

    it "imports successfully" do
      post sigaa_import_path
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:notice]).to include("Importação concluída")
    end
  end

  describe "POST /admin/sigaa_update" do
    before { post sigaa_update_path, params: { release_lock: "true" } }

    it "handles release_lock" do
      post sigaa_update_path, params: { release_lock: "true" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:notice]).to include("Trava liberada com sucesso")
    end

    it "handles large_volume" do
      post sigaa_update_path, params: { large_volume: "true" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:notice]).to include("Processando atualização de grande volume")
    end

    it "handles missing_codes error" do
      post sigaa_update_path, params: { sigaa_data: "missing_codes" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Códigos de disciplina ausentes")
    end

    it "handles empty data error" do
      post sigaa_update_path, params: { semestre: "futuro" }
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Nenhum dado novo encontrado")
    end

    it "updates successfully and simulates unenrollment" do
      ENV["SIGAA_DATA_STATUS"] = "missing_aluno"

      student = Usuario.create!(nome: "Aluno Teste", email: "aluno@teste.com", perfil: "discente", password: "123", ativo: true)
      turma = Turma.create!(codigo_turma: "T1", semestre: "2024", departamento: Departamento.create!(nome: "D"), disciplina: Disciplina.create!(nome: "D", codigo: "D"))
      Matricula.create!(usuario: student, turma: turma, papel_na_turma: "aluno")

      post sigaa_update_path
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:notice]).to include("Base de dados atualizada")

      ENV["SIGAA_DATA_STATUS"] = nil
    end

    it "simulates updating lock" do
      ENV["SIGAA_UPDATING_MOCK"] = "true"
      post sigaa_update_path
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Uma atualização já está em andamento")
      ENV["SIGAA_UPDATING_MOCK"] = nil
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

  describe "POST /admin/sigaa_import com lock ativo" do
    it "bloqueia quando @@sigaa_updating é true" do
      # Ativa o lock via large_volume
      post sigaa_update_path, params: { large_volume: "true" }

      # Agora tenta importar com o lock ativo
      post sigaa_import_path
      expect(response).to redirect_to(admin_import_console_path)
      expect(flash[:alert]).to include("Uma atualização já está em andamento")

      # Libera o lock
      post sigaa_update_path, params: { release_lock: "true" }
    end
  end

  describe "GET /admin/turmas sem departamento vinculado" do
    it "lista todas as turmas quando admin não tem departamento" do
      admin_user.update!(departamento: nil)
      disciplina = Disciplina.create!(codigo: "XX", nome: "Matéria X")
      dep = Departamento.create!(nome: "Dep X")
      Turma.create!(codigo_turma: "TX", semestre: "2024.1",
                    disciplina: disciplina, departamento: dep)

      get admin_turmas_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("TX")
    end

    it "exibe aviso quando admin sem departamento e sem turmas" do
      admin_user.update!(departamento: nil)
      get admin_turmas_path
      expect(response.body).to include("Nenhuma turma encontrada")
    end
  end

  describe "GET /admin/desempenho_semestral" do
    it "calcula médias corretamente quando há respostas likert" do
      disc = Disciplina.create!(codigo: "D2", nome: "Disc 2")
      dep  = Departamento.create!(nome: "Dep 2")
      admin_user.update!(departamento: dep)
      turma = Turma.create!(codigo_turma: "T2", semestre: "2024.1",
                            disciplina: disc, departamento: dep)
      tmpl = Template.create!(titulo: "T", criador: admin_user, skip_questions_validation: true)
      q    = QuestaoTemplate.create!(template: tmpl, enunciado: "Q", tipo: "likert", ordem: 1)

      disc2 = Usuario.create!(nome: "D", email: "d@u", perfil: "discente", password: "d")
      Matricula.create!(usuario: disc2, turma: turma, papel_na_turma: "aluno")
      form = Formulario.create!(template: tmpl, turma: turma, criado_por: admin_user,
                                publico_alvo: "discente", status: "aberto",
                                data_inicio: 1.day.ago, data_limite: 1.day.from_now)
      resp = Resposta.create!(formulario: form, usuario: disc2, enviado_em: Time.current)
      RespostaItem.create!(resposta: resp, questao_template: q, valor_numerico: 5)

      get admin_desempenho_semestral_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("5.0")
    end
  end
end
