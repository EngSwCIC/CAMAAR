require 'rails_helper'

RSpec.describe "Turmas", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente Turma",
      matricula: "doc_turma",
      email: "doc_turma@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:turma) { Turma.create!(numero_da_turma: "TA", semestre: "2026.1", disciplina: disciplina) }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /turmas" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get turmas_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get turmas_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /turmas/new" do
    it "retorna 200 OK" do
      get new_turma_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /turmas" do
    it "cria turma com sucesso (happy path)" do
      expect {
        post turmas_path, params: {
          turma: { numero_da_turma: "TC", semestre: "2026.2", disciplina_id: disciplina.id }
        }
      }.to change(Turma, :count).by(1)

      expect(response).to redirect_to(turma_url(Turma.last))
    end

    it "falha ao criar com dados inválidos (sad path)" do
      expect {
        post turmas_path, params: {
          turma: { numero_da_turma: "", semestre: "", disciplina_id: disciplina.id }
        }
      }.not_to change(Turma, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /turmas/:id" do
    it "retorna 200 OK" do
      get turma_path(turma)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /turmas/:id/edit" do
    it "retorna 200 OK" do
      get edit_turma_path(turma)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /turmas/:id" do
    it "atualiza com sucesso (happy path)" do
      patch turma_path(turma), params: {
        turma: { numero_da_turma: "TA", semestre: "2027.1", disciplina_id: disciplina.id }
      }
      turma.reload
      expect(turma.semestre).to eq("2027.1")
      expect(response).to redirect_to(turma_url(turma))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch turma_path(turma), params: {
        turma: { numero_da_turma: "", semestre: "", disciplina_id: disciplina.id }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /turmas/:id" do
    it "destrói a turma e redireciona" do
      t = Turma.create!(numero_da_turma: "TZ", semestre: "2026.1", disciplina: disciplina)
      expect {
        delete turma_path(t)
      }.to change(Turma, :count).by(-1)

      expect(response).to redirect_to(turmas_url)
    end
  end
end
