require 'rails_helper'

RSpec.describe "ElementoForms", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente EF",
      matricula: "doc_ef",
      email: "doc_ef@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:elemento_form) { ElementoForm.create!(ordem: 1, enunciado: "Questão EF", formulario: formulario) }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /elemento_forms" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get elemento_forms_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get elemento_forms_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /elemento_forms/new" do
    it "retorna 200 OK" do
      get new_elemento_form_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /elemento_forms" do
    it "cria elemento_form com sucesso (happy path)" do
      expect {
        post elemento_forms_path, params: {
          elemento_form: { ordem: 99, enunciado: "Novo EF", formulario_id: formulario.id }
        }
      }.to change(ElementoForm, :count).by(1)

      expect(response).to redirect_to(elemento_form_url(ElementoForm.last))
    end

    it "falha ao criar sem ordem (sad path)" do
      expect {
        post elemento_forms_path, params: {
          elemento_form: { ordem: nil, enunciado: "EF", formulario_id: formulario.id }
        }
      }.not_to change(ElementoForm, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /elemento_forms/:id" do
    it "retorna 200 OK" do
      get elemento_form_path(elemento_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /elemento_forms/:id/edit" do
    it "retorna 200 OK" do
      get edit_elemento_form_path(elemento_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /elemento_forms/:id" do
    it "atualiza com sucesso (happy path)" do
      patch elemento_form_path(elemento_form), params: {
        elemento_form: { ordem: 1, enunciado: "EF Atualizado", formulario_id: formulario.id }
      }
      elemento_form.reload
      expect(elemento_form.enunciado).to eq("EF Atualizado")
      expect(response).to redirect_to(elemento_form_url(elemento_form))
    end

    it "falha ao atualizar sem ordem (sad path)" do
      patch elemento_form_path(elemento_form), params: {
        elemento_form: { ordem: nil, enunciado: "EF", formulario_id: formulario.id }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /elemento_forms/:id" do
    it "destrói o elemento_form e redireciona" do
      ef = ElementoForm.create!(ordem: 50, formulario: formulario)
      expect {
        delete elemento_form_path(ef)
      }.to change(ElementoForm, :count).by(-1)

      expect(response).to redirect_to(elemento_forms_url)
    end
  end
end
