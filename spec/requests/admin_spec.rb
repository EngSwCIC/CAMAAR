require 'rails_helper'

RSpec.describe "Admin", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:admin) do
    Administrador.create!(
      nome: "Admin Teste",
      matricula: "adm_admin",
      email: "admin_ctrl@unb.br",
      senha: "Senha123",
      senha_confirmation: "Senha123",
      departamento: departamento
    )
  end

  before { post login_path, params: { login: admin.email, senha: "Senha123" } }

  describe "GET /admin/:admin_id/avaliacoes" do
    it "retorna 200 OK" do
      get admin_avaliacoes_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/:admin_id/gerenciamento" do
    it "retorna 200 OK" do
      get admin_gerenciamento_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "Controle de acesso" do
    let!(:outro_admin) do
      Administrador.create!(
        nome: "Outro Admin",
        matricula: "adm_outro",
        email: "outro_admin@unb.br",
        senha: "Senha123",
        senha_confirmation: "Senha123",
        departamento: departamento
      )
    end

    it "redireciona ao tentar acessar páginas de outro administrador" do
      get admin_gerenciamento_path(admin_id: outro_admin.id)
      expect(response).to redirect_to(inicio_path)
    end
  end

  describe "GET /admin/:admin_id/enviar_formularios" do
    it "retorna 200 OK" do
      get admin_enviar_formularios_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/:admin_id/enviar_formularios" do
    let(:disciplina) { Disciplina.find_or_create_by!(nome: "ES", codigo: "CIC001A", departamento: departamento) }
    let!(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
    let!(:template) do
      t = admin.templates.build(nome: "Template Ctrl")
      t.elementos.build(enunciado: "Questão 1", ordem: 1)
      t.save!
      t
    end

    it "redireciona com alerta quando template não informado" do
      post admin_enviar_formularios_path(admin_id: admin.id), params: {
        template_id: nil,
        turma_ids: [ turma.id ]
      }
      expect(response).to redirect_to(admin_enviar_formularios_path(admin))
      expect(flash[:alert]).to include("Selecione um template")
    end

    it "redireciona com alerta quando turmas não informadas" do
      post admin_enviar_formularios_path(admin_id: admin.id), params: {
        template_id: template.id,
        turma_ids: nil
      }
      expect(response).to redirect_to(admin_enviar_formularios_path(admin))
      expect(flash[:alert]).to include("Selecione pelo menos uma turma")
    end

    it "cria formulário com sucesso para uma turma" do
      expect {
        post admin_enviar_formularios_path(admin_id: admin.id), params: {
          template_id: template.id,
          turma_ids: [ turma.id ]
        }
      }.to change(Formulario, :count).by(1)

      expect(response).to redirect_to(admin_gerenciamento_path(admin))
      expect(flash[:notice]).to eq("Formulário criado com sucesso")
    end

    it "cria múltiplos formulários para múltiplas turmas" do
      outra_turma = Turma.create!(numero_da_turma: "TB", disciplina: disciplina, semestre: "2026.1")

      expect {
        post admin_enviar_formularios_path(admin_id: admin.id), params: {
          template_id: template.id,
          turma_ids: [ turma.id, outra_turma.id ]
        }
      }.to change(Formulario, :count).by(2)

      expect(flash[:notice]).to eq("Formulários criados com sucesso")
    end

    it "cria elemento_forms associados ao formulário" do
      post admin_enviar_formularios_path(admin_id: admin.id), params: {
        template_id: template.id,
        turma_ids: [ turma.id ]
      }
      formulario = Formulario.last
      expect(formulario.elemento_forms.count).to eq(1)
    end
  end

  describe "GET /admin/:admin_id/resultados" do
    it "retorna 200 OK" do
      get admin_resultados_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/:admin_id/resultados/:id/download.csv" do
    let(:disciplina) { Disciplina.find_or_create_by!(nome: "ES Download", codigo: "CIC002A", departamento: departamento) }
    let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
    let!(:formulario) { Formulario.create!(turma: turma) }
    let(:docente) do
      Docente.find_or_create_by!(email: "doc_csv@unb.br") do |d|
        d.nome = "Docente CSV"
        d.matricula = "doc_csv"
        d.formacao = "Doutorado"
        d.senha = "Senha123"
      end
    end

    it "redireciona com alerta quando formulário não encontrado" do
      get admin_baixar_csv_path(admin_id: admin.id, id: 999999)
      expect(response).to redirect_to(admin_resultados_path(admin))
      expect(flash[:alert]).to include("não encontrado")
    end

    it "redireciona com alerta quando formulário sem respostas" do
      get admin_baixar_csv_path(admin_id: admin.id, id: formulario.id)
      expect(response).to redirect_to(admin_resultados_path(admin))
      expect(flash[:alert]).to include("não possui respostas")
    end

    it "retorna CSV quando formulário tem respostas" do
      RespostaForm.create!(formulario: formulario, usuario: docente, data_submissao: Date.today)
      get admin_baixar_csv_path(admin_id: admin.id, id: formulario.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /admin/:admin_id/sincronizar_sigaa" do
    it "renderiza a página de sincronização" do
      get admin_sincronizar_sigaa_path(admin_id: admin.id)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /admin/:admin_id/sincronizar_sigaa" do
    let(:json_file) { fixture_file_upload(Rails.root.join("class_members.json"), "application/json") }

    it "redireciona com alerta quando arquivos ausentes" do
      post admin_sincronizar_sigaa_path(admin_id: admin.id), params: { acao: "importar" }
      expect(response).to be_redirect
    end

    context "com SigaaImporter mockado" do
      it "importar com resultado 'alguns dados'" do
        allow(SigaaImporter).to receive(:import_from_files).and_return("alguns dados já foram importados")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "importar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
      end

      it "atualizar com resultado 'alguns dados'" do
        allow(SigaaImporter).to receive(:update_from_files).and_return("alguns dados já estão atualizados")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "atualizar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
      end

      it "importar com resultado 'sucesso'" do
        allow(SigaaImporter).to receive(:import_from_files).and_return("importação realizada com sucesso")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "importar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
        expect(flash[:notice]).to include("estão presentes no sistema")
      end

      it "atualizar com resultado 'sucesso'" do
        allow(SigaaImporter).to receive(:update_from_files).and_return("atualização realizada com sucesso")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "atualizar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
        expect(flash[:notice]).to include("atualizados no sistema")
      end

      it "importar com resultado 'já existem'" do
        allow(SigaaImporter).to receive(:import_from_files).and_return("os dados já existem")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "importar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
        expect(flash[:alert]).to be_present
      end

      it "atualizar com resultado 'já estão atualizados'" do
        allow(SigaaImporter).to receive(:update_from_files).and_return("os dados já estão atualizados")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "atualizar", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
        expect(flash[:alert]).to be_present
      end

      it "ação inválida resulta em redirect com alert" do
        allow(SigaaImporter).to receive(:import_from_files).and_return("ação inválida")
        post admin_sincronizar_sigaa_path(admin_id: admin.id), params: {
          acao: "invalida", arquivo_classes: json_file, arquivo_membros: json_file
        }
        expect(response).to redirect_to(admin_gerenciamento_path(admin))
        expect(flash[:alert]).to be_present
      end
    end
  end
end
