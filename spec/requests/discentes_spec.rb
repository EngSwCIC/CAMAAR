require 'rails_helper'

RSpec.describe "Discentes", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:curso) { Curso.find_or_create_by!(nome: "Engenharia de Software", codigo: "ESW_D", departamento: departamento) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente Disc2",
      matricula: "doc_disc2",
      email: "doc_disc2@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:discente) do
    Discente.create!(
      nome: "Discente Teste",
      matricula: "disc_teste",
      email: "disc_teste@unb.br",
      curso: curso,
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /discentes" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get discentes_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get discentes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /discentes/new" do
    it "retorna 200 OK" do
      get new_discente_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /discentes" do
    it "cria discente com sucesso (happy path)" do
      expect {
        post discentes_path, params: {
          discente: { nome: "Novo Aluno", matricula: "disc_novo", email: "disc_novo@unb.br", curso_id: curso.id }
        }
      }.to change(Discente, :count).by(1)

      expect(response).to redirect_to(discente_url(Discente.last))
    end

    it "falha ao criar com dados inválidos (sad path)" do
      expect {
        post discentes_path, params: {
          discente: { nome: "", matricula: "", email: "", curso_id: nil }
        }
      }.not_to change(Discente, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /discentes/:id" do
    it "retorna 200 OK" do
      get discente_path(discente)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /discentes/:id/edit" do
    it "retorna 200 OK" do
      get edit_discente_path(discente)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /discentes/:id" do
    it "atualiza com sucesso (happy path)" do
      patch discente_path(discente), params: {
        discente: { nome: "Aluno Atualizado", matricula: discente.matricula, email: discente.email, curso_id: curso.id }
      }
      discente.reload
      expect(discente.nome).to eq("Aluno Atualizado")
      expect(response).to redirect_to(discente_url(discente))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch discente_path(discente), params: {
        discente: { nome: "", matricula: "", email: "", curso_id: nil }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /discentes/:id" do
    it "destrói o discente e redireciona" do
      d = Discente.create!(nome: "Para Deletar", matricula: "del_disc", email: "del_disc@unb.br", curso: curso)
      expect {
        delete discente_path(d)
      }.to change(Discente, :count).by(-1)

      expect(response).to redirect_to(discentes_url)
    end
  end
end
