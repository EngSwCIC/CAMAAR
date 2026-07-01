require 'rails_helper'

RSpec.describe "Cursos", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:docente) do
    Docente.create!(
      nome: "Docente Cursos",
      matricula: "doc_cursos",
      email: "doc_cursos@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:curso) { Curso.create!(nome: "Engenharia de Software", codigo: "ESW01", departamento: departamento) }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /cursos" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get cursos_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get cursos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /cursos/new" do
    it "retorna 200 OK" do
      get new_curso_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /cursos" do
    it "cria curso com sucesso (happy path)" do
      expect {
        post cursos_path, params: { curso: { nome: "Novo Curso", codigo: "NC01", departamento_id: departamento.id } }
      }.to change(Curso, :count).by(1)

      expect(response).to redirect_to(curso_url(Curso.last))
    end

    it "falha ao criar curso com dados inválidos (sad path)" do
      expect {
        post cursos_path, params: { curso: { nome: "", codigo: "", departamento_id: departamento.id } }
      }.not_to change(Curso, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /cursos/:id" do
    it "retorna 200 OK" do
      get curso_path(curso)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /cursos/:id/edit" do
    it "retorna 200 OK" do
      get edit_curso_path(curso)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /cursos/:id" do
    it "atualiza curso com sucesso (happy path)" do
      patch curso_path(curso), params: { curso: { nome: "Nome Atualizado", codigo: curso.codigo, departamento_id: departamento.id } }
      curso.reload
      expect(curso.nome).to eq("Nome Atualizado")
      expect(response).to redirect_to(curso_url(curso))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch curso_path(curso), params: { curso: { nome: "", codigo: "", departamento_id: departamento.id } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /cursos/:id" do
    it "destrói o curso e redireciona" do
      expect {
        delete curso_path(curso)
      }.to change(Curso, :count).by(-1)

      expect(response).to redirect_to(cursos_url)
    end
  end
end
