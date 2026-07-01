require 'rails_helper'

RSpec.describe "Disciplinas", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let!(:docente) do
    Docente.create!(
      nome: "Docente Disc",
      matricula: "doc_disc",
      email: "doc_disc@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:disciplina) { Disciplina.create!(nome: "Álgebra Linear", codigo: "MAT001D", departamento: departamento) }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /disciplinas" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get disciplinas_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get disciplinas_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /disciplinas/new" do
    it "retorna 200 OK" do
      get new_disciplina_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /disciplinas" do
    it "cria disciplina com sucesso (happy path)" do
      expect {
        post disciplinas_path, params: {
          disciplina: { nome: "Cálculo 1", codigo: "MAT002D", departamento_id: departamento.id }
        }
      }.to change(Disciplina, :count).by(1)

      expect(response).to redirect_to(disciplina_url(Disciplina.last))
    end

    it "falha ao criar com dados inválidos (sad path)" do
      expect {
        post disciplinas_path, params: {
          disciplina: { nome: "", codigo: "", departamento_id: departamento.id }
        }
      }.not_to change(Disciplina, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /disciplinas/:id" do
    it "retorna 200 OK" do
      get disciplina_path(disciplina)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /disciplinas/:id/edit" do
    it "retorna 200 OK" do
      get edit_disciplina_path(disciplina)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /disciplinas/:id" do
    it "atualiza com sucesso (happy path)" do
      patch disciplina_path(disciplina), params: {
        disciplina: { nome: "Álgebra Linear Avançada", codigo: disciplina.codigo, departamento_id: departamento.id }
      }
      disciplina.reload
      expect(disciplina.nome).to eq("Álgebra Linear Avançada")
      expect(response).to redirect_to(disciplina_url(disciplina))
    end

    it "falha ao atualizar com dados inválidos (sad path)" do
      patch disciplina_path(disciplina), params: {
        disciplina: { nome: "", codigo: "", departamento_id: departamento.id }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /disciplinas/:id" do
    it "destrói a disciplina e redireciona" do
      disc = Disciplina.create!(nome: "Para Deletar", codigo: "DEL001D", departamento: departamento)
      expect {
        delete disciplina_path(disc)
      }.to change(Disciplina, :count).by(-1)

      expect(response).to redirect_to(disciplinas_url)
    end
  end
end
