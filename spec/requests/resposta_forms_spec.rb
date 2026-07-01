require 'rails_helper'

RSpec.describe "RespostaForms", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente RF2",
      matricula: "doc_rf2",
      email: "doc_rf2@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let!(:resposta_form) do
    RespostaForm.create!(data_submissao: Date.today, formulario: formulario, usuario: docente)
  end

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /resposta_forms" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get resposta_forms_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get resposta_forms_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /resposta_forms/new" do
    it "retorna 200 OK" do
      get new_resposta_form_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /resposta_forms" do
    let(:outro_formulario) { Formulario.create!(turma: turma) }
    let(:outro_docente) do
      Docente.create!(
        nome: "Docente RF3",
        matricula: "doc_rf3",
        email: "doc_rf3@unb.br",
        formacao: "Mestrado",
        senha: "Senha123",
        senha_confirmation: "Senha123"
      )
    end

    it "cria resposta_form com sucesso (happy path)" do
      expect {
        post resposta_forms_path, params: {
          resposta_form: {
            data_submissao: Date.today,
            formulario_id: outro_formulario.id,
            usuario_id: docente.id
          }
        }
      }.to change(RespostaForm, :count).by(1)

      expect(response).to redirect_to(resposta_form_url(RespostaForm.last))
    end

    it "falha ao criar sem data_submissao (sad path)" do
      expect {
        post resposta_forms_path, params: {
          resposta_form: {
            data_submissao: nil,
            formulario_id: formulario.id,
            usuario_id: outro_docente.id
          }
        }
      }.not_to change(RespostaForm, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /resposta_forms/:id" do
    it "retorna 200 OK" do
      get resposta_form_path(resposta_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /resposta_forms/:id/edit" do
    it "retorna 200 OK" do
      get edit_resposta_form_path(resposta_form)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /resposta_forms/:id" do
    let(:outro_formulario) { Formulario.create!(turma: turma) }

    it "atualiza com sucesso (happy path)" do
      patch resposta_form_path(resposta_form), params: {
        resposta_form: {
          data_submissao: Date.yesterday,
          formulario_id: resposta_form.formulario_id,
          usuario_id: resposta_form.usuario_id
        }
      }
      resposta_form.reload
      expect(resposta_form.data_submissao).to eq(Date.yesterday)
      expect(response).to redirect_to(resposta_form_url(resposta_form))
    end

    it "falha ao atualizar sem data_submissao (sad path)" do
      patch resposta_form_path(resposta_form), params: {
        resposta_form: {
          data_submissao: nil,
          formulario_id: resposta_form.formulario_id,
          usuario_id: resposta_form.usuario_id
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /resposta_forms/:id" do
    it "destrói a resposta_form e redireciona" do
      outro_doc = Docente.create!(nome: "Del RF", matricula: "del_rf", email: "del_rf@unb.br", formacao: "Grad")
      outro_form = Formulario.create!(turma: turma)
      rf = RespostaForm.create!(data_submissao: Date.today, formulario: outro_form, usuario: outro_doc)

      expect {
        delete resposta_form_path(rf)
      }.to change(RespostaForm, :count).by(-1)

      expect(response).to redirect_to(resposta_forms_url)
    end
  end
end
