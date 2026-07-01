require 'rails_helper'

RSpec.describe "Docentes", type: :request do
  let!(:docente) do
    Docente.create!(
      nome: "Docente Principal",
      matricula: "doc_princ",
      email: "doc_princ@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /docentes" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get docentes_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get docentes_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /docentes/new" do
    it "retorna 200 OK" do
      get new_docente_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /docentes" do
    it "cria docente com sucesso (happy path)" do
      expect {
        post docentes_path, params: {
          docente: { nome: "Novo Docente", matricula: "doc_novo", email: "doc_novo@unb.br", formacao: "Mestrado" }
        }
      }.to change(Docente, :count).by(1)

      expect(response).to redirect_to(docente_url(Docente.last))
    end

    it "falha ao criar com dados inválidos (sad path)" do
      expect {
        post docentes_path, params: {
          docente: { nome: "", matricula: "", email: "", formacao: "" }
        }
      }.not_to change(Docente, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /docentes/:id" do
    it "retorna 200 OK" do
      get docente_path(docente)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /docentes/:id/edit" do
    it "retorna 200 OK" do
      get edit_docente_path(docente)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /docentes/:id" do
    it "atualiza com sucesso (happy path)" do
      patch docente_path(docente), params: {
        docente: { nome: "Nome Atualizado", matricula: docente.matricula, email: docente.email, formacao: "PhD" }
      }
      docente.reload
      expect(docente.nome).to eq("Nome Atualizado")
      expect(response).to redirect_to(docente_url(docente))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch docente_path(docente), params: {
        docente: { nome: "", matricula: "", email: "", formacao: "" }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /docentes/:id" do
    it "destrói o docente e redireciona" do
      d = Docente.create!(nome: "Para Deletar", matricula: "del_doc", email: "del_doc@unb.br", formacao: "Grad")
      expect {
        delete docente_path(d)
      }.to change(Docente, :count).by(-1)

      expect(response).to redirect_to(docentes_url)
    end
  end
end
