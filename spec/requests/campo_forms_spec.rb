require 'rails_helper'

RSpec.describe "CampoForms", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let(:elemento_form) { ElementoForm.create!(ordem: 1, formulario: formulario) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente CF",
      matricula: "doc_cf",
      email: "doc_cf@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:campo_form) { CampoForm.create!(ordem: 1, enunciado: "Opção A", elemento_form: elemento_form) }

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /campo_forms" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get campo_forms_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get campo_forms_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /campo_forms/new" do
    it "retorna 200 OK" do
      get new_campo_form_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /campo_forms" do
    it "cria campo_form com sucesso (happy path)" do
      expect {
        post campo_forms_path, params: {
          campo_form: { ordem: 99, enunciado: "Nova Opção", elemento_form_id: elemento_form.id }
        }
      }.to change(CampoForm, :count).by(1)

      expect(response).to redirect_to(campo_form_url(CampoForm.last))
    end

    it "falha ao criar sem ordem (sad path)" do
      expect {
        post campo_forms_path, params: {
          campo_form: { ordem: nil, enunciado: "X", elemento_form_id: elemento_form.id }
        }
      }.not_to change(CampoForm, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /campo_forms/:id" do
    it "retorna 200 OK" do
      get campo_form_path(campo_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /campo_forms/:id/edit" do
    it "retorna 200 OK" do
      get edit_campo_form_path(campo_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /campo_forms/:id" do
    it "atualiza com sucesso (happy path)" do
      patch campo_form_path(campo_form), params: {
        campo_form: { ordem: 1, enunciado: "Opção Atualizada", elemento_form_id: elemento_form.id }
      }
      campo_form.reload
      expect(campo_form.enunciado).to eq("Opção Atualizada")
      expect(response).to redirect_to(campo_form_url(campo_form))
    end

    it "falha ao atualizar sem ordem (sad path)" do
      patch campo_form_path(campo_form), params: {
        campo_form: { ordem: nil, enunciado: "X", elemento_form_id: elemento_form.id }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /campo_forms/:id" do
    it "destrói o campo_form e redireciona" do
      cf = CampoForm.create!(ordem: 50, elemento_form: elemento_form)
      expect {
        delete campo_form_path(cf)
      }.to change(CampoForm, :count).by(-1)

      expect(response).to redirect_to(campo_forms_url)
    end
  end
end
