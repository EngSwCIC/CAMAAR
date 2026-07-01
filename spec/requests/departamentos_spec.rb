require 'rails_helper'

RSpec.describe "Departamentos", type: :request do
  let!(:docente) do
    Docente.create!(
      nome: "Docente Dep",
      matricula: "doc_dep",
      email: "doc_dep@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:departamento) { Departamento.create!(nome: "Matemática", codigo: "MAT01") }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /departamentos" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get departamentos_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get departamentos_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /departamentos/new" do
    it "retorna 200 OK" do
      get new_departamento_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /departamentos" do
    it "cria departamento com sucesso (happy path)" do
      expect {
        post departamentos_path, params: { departamento: { nome: "Física", codigo: "FIS01" } }
      }.to change(Departamento, :count).by(1)

      expect(response).to redirect_to(departamento_url(Departamento.last))
    end

    it "falha ao criar com dados inválidos (sad path)" do
      expect {
        post departamentos_path, params: { departamento: { nome: "", codigo: "" } }
      }.not_to change(Departamento, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /departamentos/:id" do
    it "retorna 200 OK" do
      get departamento_path(departamento)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /departamentos/:id/edit" do
    it "retorna 200 OK" do
      get edit_departamento_path(departamento)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /departamentos/:id" do
    it "atualiza com sucesso (happy path)" do
      patch departamento_path(departamento), params: { departamento: { nome: "Matemática Aplicada", codigo: departamento.codigo } }
      departamento.reload
      expect(departamento.nome).to eq("Matemática Aplicada")
      expect(response).to redirect_to(departamento_url(departamento))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch departamento_path(departamento), params: { departamento: { nome: "", codigo: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /departamentos/:id" do
    it "destrói o departamento e redireciona" do
      dep = Departamento.create!(nome: "Para Deletar", codigo: "DEL01")
      expect {
        delete departamento_path(dep)
      }.to change(Departamento, :count).by(-1)

      expect(response).to redirect_to(departamentos_url)
    end
  end
end
