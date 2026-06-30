require 'rails_helper'

RSpec.describe "Formularios e Avaliações", type: :request do
  describe "Visibilidade por Público-Alvo (Issue #113)" do
    let(:departamento) { Departamento.create!(nome: "Dep") }
    let(:disciplina) { Disciplina.create!(nome: "Disc", codigo: "D1") }
    let(:docente) do
      Usuario.create!(nome: "Prof", email: "prof@unb.br", perfil: "docente", password: "123", ativo: true)
    end
    let(:discente) do
      Usuario.create!(nome: "Aluno", email: "aluno@unb.br", perfil: "discente", password: "123", ativo: true)
    end
    let(:turma) { Turma.create!(codigo_turma: "T1", semestre: "2024.1", departamento: departamento, disciplina: disciplina, docente: docente) }
    let(:admin) { Usuario.create!(nome: "Admin", email: "adm@unb.br", perfil: "administrador", password: "123") }
    let(:template) { Template.create!(titulo: "Temp", ativo: true, criador_id: admin.id, skip_questions_validation: true) }

    before do
      Matricula.create!(usuario: discente, turma: turma, papel_na_turma: "aluno")
    end

    context "quando o formulário é para Discentes" do
      it "exibe o formulário no painel do aluno e oculta no painel do professor" do
        form_discente = Formulario.create!(
          turma: turma, publico_alvo: "discente", status: "aberto", template: template,
          data_inicio: Time.current - 1.day, data_limite: Time.current + 1.day, criado_por: admin
        )

        # Login Discente
        post login_path, params: { email: discente.email, password: "123" }
        get avaliacoes_path
        expect(response.body).to include("Disc") # Formulário visível

        # Logout e Login Docente
        delete logout_path
        post login_path, params: { email: docente.email, password: "123" }
        get avaliacoes_path
        expect(response.body).not_to include("Disc") # Formulário invisível
      end
    end

    context "quando o formulário é para Docentes" do
      it "exibe o formulário no painel do professor e oculta no painel dos alunos" do
        form_docente = Formulario.create!(
          turma: turma, publico_alvo: "docente", status: "aberto", template: template,
          data_inicio: Time.current - 1.day, data_limite: Time.current + 1.day, criado_por: admin
        )

        # Login Docente
        post login_path, params: { email: docente.email, password: "123" }
        get avaliacoes_path
        expect(response.body).to include("Disc") # Formulário visível

        # Logout e Login Discente
        delete logout_path
        post login_path, params: { email: discente.email, password: "123" }
        get avaliacoes_path
        expect(response.body).not_to include("Disc") # Formulário invisível
      end
    end

    context "Cenário de Erro: Envio de datas em branco" do
      it "não permite a criação do formulário se as datas de início e limite estiverem vazias" do
        post login_path, params: { email: admin.email, password: "123" }

        post formularios_path, params: {
          turma_id: turma.id,
          formulario: {
            template_id: template.id,
            publico_alvo: "discente",
            data_inicio: "",
            data_limite: ""
          }
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Datas de início e limite são obrigatórias")
        expect(Formulario.count).to eq(0)
      end
    end

    context "Cenário de Erro: Público Alvo Inválido" do
      it "exige público alvo" do
        post login_path, params: { email: admin.email, password: "123" }
        post formularios_path, params: {
          turma_id: turma.id,
          formulario: {
            template_id: template.id,
            publico_alvo: "",
            data_inicio: Time.now,
            data_limite: Time.now + 1.day
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Obrigatório: Selecione")
      end
    end

    context "Cenário de Erro: Template inativo" do
      it "não permite template inativo" do
        post login_path, params: { email: admin.email, password: "123" }
        template_inativo = Template.create!(titulo: "Inativo", ativo: false, criador_id: admin.id, skip_questions_validation: true)
        post formularios_path, params: {
          turma_id: turma.id,
          formulario: {
            template_id: template_inativo.id,
            publico_alvo: "discente",
            data_inicio: Time.now,
            data_limite: Time.now + 1.day
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("templates inativos")
      end
    end

    context "Cenário Batch: Criação em lote" do
      it "cria múltiplos formulários quando envia turma_ids" do
        post login_path, params: { email: admin.email, password: "123" }
        turma2 = Turma.create!(codigo_turma: "T2", semestre: "2024.1", departamento: departamento, disciplina: disciplina, docente: docente)
        discente = Usuario.create!(nome: "Discente Teste", email: "discente@teste.com", perfil: "discente", password: "123", ativo: true)
        Matricula.create!(usuario: discente, turma: turma, papel_na_turma: "aluno")
        Matricula.create!(usuario: discente, turma: turma2, papel_na_turma: "aluno")
        post formularios_path, params: {
          turma_ids: [ turma.id, turma2.id ],
          formulario: {
            template_id: template.id,
            publico_alvo: "discente"
          }
        }
        expect(response).to redirect_to(admin_dashboard_path)
        expect(Formulario.count).to eq(2)
      end

      it "redireciona com erro se não enviar turma_ids" do
        post login_path, params: { email: admin.email, password: "123" }
        post formularios_path, params: {
          turma_ids: nil,
          formulario: {
            template_id: template.id,
            publico_alvo: "discente"
          }
        }
        expect(response).to redirect_to(new_formulario_path)
        expect(flash[:alert]).to include("Selecione pelo menos uma turma")
      end

      it "falha se uma criação no lote falhar" do
        post login_path, params: { email: admin.email, password: "123" }
        allow_any_instance_of(Formulario).to receive(:save).and_return(false)
        allow_any_instance_of(Formulario).to receive_message_chain(:errors, :full_messages, :first).and_return("Erro Simulado")

        post formularios_path, params: {
          turma_ids: [ turma.id ],
          formulario: {
            template_id: template.id,
            publico_alvo: "discente"
          }
        }
        expect(response).to redirect_to(new_formulario_path)
        expect(flash[:alert]).to include("Erro Simulado")
      end
    end
  end

  describe "GET /formularios/new" do
    it "renders the new form" do
      admin = Usuario.create!(nome: "Admin", email: "adm_new@unb.br", perfil: "administrador", password: "123")
      post login_path, params: { email: admin.email, password: "123" }
      get new_formulario_path
      expect(response).to have_http_status(:success)
    end
  end
end
