require 'rails_helper'

RSpec.describe "Templates", type: :request do
  let(:admin) { Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true) }

  before do
    post login_path, params: { email: admin.email, password: "senha" }
  end

  describe "GET /templates" do
    it "renders index" do
      get templates_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /templates" do
    it "fails to create a template without title" do
      post templates_path, params: {
        template: {
          titulo: "",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "Pergunta 1", tipo: "aberta" }
          ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Nome do Template não pode ficar em branco")
      expect(Template.count).to eq(0)
    end

    it "fails to create a template without any valid questions" do
      post templates_path, params: {
        template: {
          titulo: "Template 1",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "", tipo: "aberta" }
          ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("O template deve ter ao menos uma pergunta")
      expect(Template.count).to eq(0)
    end

    it "creates a template with valid data" do
      post templates_path, params: {
        template: {
          titulo: "Template 1",
          perfil_alvo: "discente",
          perguntas: [
            { texto: "Pergunta 1", tipo: "aberta" }
          ]
        }
      }
      expect(response).to redirect_to(templates_path)
      expect(Template.count).to eq(1)
      expect(Template.first.perguntas.count).to eq(1)
    end

    it "handles save error due to database exception" do
      allow_any_instance_of(Template).to receive(:save).and_return(false)
      post templates_path, params: {
        template: {
          titulo: "Template Error",
          perfil_alvo: "discente",
          perguntas: [ { texto: "Pergunta", tipo: "aberta" } ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Não foi possível salvar o template")
    end

    it "handles save error due to raised exception" do
      allow_any_instance_of(Template).to receive(:save).and_raise(StandardError.new("DB Error"))
      post templates_path, params: {
        template: {
          titulo: "Template Error 2",
          perfil_alvo: "discente",
          perguntas: [ { texto: "Pergunta", tipo: "aberta" } ]
        }
      }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Erro ao criar template")
    end
  end

  describe "GET /templates/:id/edit" do
    it "renders edit" do
      template = Template.create!(titulo: "Test", criador: admin, perfil_alvo: "discente", skip_questions_validation: true)
      get edit_template_path(template)
      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /templates/:id" do
    let(:template) do
      t = Template.create!(titulo: "Old Title", criador: admin, perfil_alvo: "discente", skip_questions_validation: true)
      QuestaoTemplate.create!(template: t, enunciado: "Q1", tipo: "aberta", obrigatoria: true, ordem: 1)
      t
    end

    it "updates the template successfully" do
      patch template_path(template), params: { template: { titulo: "New Title" } }
      expect(response).to redirect_to(templates_path)
      expect(template.reload.titulo).to eq("New Title")
    end

    it "fails to update with invalid data" do
      allow_any_instance_of(Template).to receive(:update).and_return(false)
      patch template_path(template), params: { template: { titulo: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Não foi possível atualizar o template")
    end
  end

  describe "DELETE /templates/:id" do
    let(:template) { Template.create!(titulo: "To Delete", criador: admin, perfil_alvo: "discente", skip_questions_validation: true) }

    it "deletes the template successfully" do
      delete template_path(template)
      expect(response).to redirect_to(templates_path)
      expect(Template.exists?(template.id)).to be_falsey
    end

    it "fails to delete if it has formularies" do
      disc = Disciplina.create!(nome: "D1", codigo: "D1_del")
      turma = Turma.create!(codigo_turma: "T1", semestre: "2024", departamento: Departamento.create!(nome: "D_del"), disciplina: disc)
      discente = Usuario.create!(nome: "Aluno Teste", email: "aluno_del@teste.com", perfil: "discente", password: "123", ativo: true)
      Matricula.create!(usuario: discente, turma: turma, papel_na_turma: "aluno")
      Formulario.create!(template: template, turma_id: turma.id, criado_por: admin, publico_alvo: "discente", status: "aberto", data_inicio: Time.now, data_limite: Time.now + 1.day)

      delete template_path(template)
      expect(response).to redirect_to(templates_path)
      expect(Template.exists?(template.id)).to be_truthy
      follow_redirect!
      expect(response.body).to include("Não é possível deletar este template")
    end
  end

  context "Cenários Tristes: Usuário sem permissão administrativa" do
    let(:aluno_user) { Usuario.create!(nome: "Aluno", email: "aluno@unb.br", perfil: "discente", password: "senha", ativo: true) }

    it "bloqueia criação de template por estudante" do
      delete logout_path
      post login_path, params: { email: aluno_user.email, password: "senha" }

      post templates_path, params: {
        template: {
          titulo: "Template Pirata",
          perfil_alvo: "discente",
          perguntas: [ { texto: "P1", tipo: "aberta" } ]
        }
      }
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("Acesso negado. Esta área é restrita para administradores.")
      expect(Template.count).to eq(0)
    end
  end
end
