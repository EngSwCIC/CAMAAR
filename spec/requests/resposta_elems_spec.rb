require 'rails_helper'

RSpec.describe "RespostaElems", type: :request do
  let(:departamento) { Departamento.find_or_create_by!(nome: "Ciência da Computação", codigo: "CIC") }
  let(:disciplina) { Disciplina.find_or_create_by!(nome: "Engenharia de Software", codigo: "CIC0097", departamento: departamento) }
  let(:turma) { Turma.find_or_create_by!(numero_da_turma: "TA", disciplina: disciplina, semestre: "2026.1") }
  let(:formulario) { Formulario.create!(turma: turma) }
  let(:elemento_form) { ElementoForm.create!(ordem: 1, tipo: "Texto", formulario: formulario) }
  let!(:docente) do
    Docente.create!(
      nome: "Docente RE2",
      matricula: "doc_re2",
      email: "doc_re2@unb.br",
      formacao: "Doutorado",
      senha: "Senha123",
      senha_confirmation: "Senha123"
    )
  end
  let(:resposta_form) do
    RespostaForm.create!(data_submissao: Date.today, formulario: formulario, usuario: docente)
  end
  let!(:resposta_elem) do
    RespostaElem.create!(
      texto_resposta: "Resposta inicial",
      resposta_form: resposta_form,
      elemento_form: elemento_form
    )
  end

  before { post login_path, params: { login: docente.email, senha: "Senha123" } }

  describe "GET /resposta_elems" do
    it "sem sessão ativa redireciona para login" do
      delete logout_path
      get resposta_elems_path
      expect(response).to redirect_to(root_path)
    end

    it "retorna 200 OK" do
      get resposta_elems_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /resposta_elems/new" do
    it "retorna 200 OK" do
      get new_resposta_elem_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /resposta_elems" do
    let(:outro_ef) { ElementoForm.create!(ordem: 2, formulario: formulario) }

    it "cria resposta_elem com sucesso (happy path)" do
      expect {
        post resposta_elems_path, params: {
          resposta_elem: {
            texto_resposta: "Nova Resposta",
            resposta_form_id: resposta_form.id,
            elemento_form_id: outro_ef.id
          }
        }
      }.to change(RespostaElem, :count).by(1)

      expect(response).to redirect_to(resposta_elem_url(RespostaElem.last))
    end

    it "falha ao criar sem texto_resposta (sad path)" do
      expect {
        post resposta_elems_path, params: {
          resposta_elem: {
            texto_resposta: "",
            resposta_form_id: resposta_form.id,
            elemento_form_id: outro_ef.id
          }
        }
      }.not_to change(RespostaElem, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "GET /resposta_elems/:id" do
    it "retorna 200 OK" do
      get resposta_elem_path(resposta_elem)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /resposta_elems/:id/edit" do
    it "retorna 200 OK" do
      get edit_resposta_elem_path(resposta_elem)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH /resposta_elems/:id" do
    it "atualiza com sucesso (happy path)" do
      patch resposta_elem_path(resposta_elem), params: {
        resposta_elem: {
          texto_resposta: "Texto Atualizado",
          resposta_form_id: resposta_form.id,
          elemento_form_id: elemento_form.id
        }
      }
      resposta_elem.reload
      expect(resposta_elem.texto_resposta).to eq("Texto Atualizado")
      expect(response).to redirect_to(resposta_elem_url(resposta_elem))
    end

    it "falha ao atualizar sem texto_resposta (sad path)" do
      patch resposta_elem_path(resposta_elem), params: {
        resposta_elem: {
          texto_resposta: "",
          resposta_form_id: resposta_form.id,
          elemento_form_id: elemento_form.id
        }
      }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "DELETE /resposta_elems/:id" do
    it "destrói a resposta_elem e redireciona" do
      outro_doc = Docente.create!(nome: "Del RE", matricula: "del_re", email: "del_re@unb.br", formacao: "Grad")
      outro_form_obj = Formulario.create!(turma: turma)
      outro_ef2 = ElementoForm.create!(ordem: 1, formulario: outro_form_obj)
      outro_rf = RespostaForm.create!(data_submissao: Date.today, formulario: outro_form_obj, usuario: outro_doc)
      re = RespostaElem.create!(texto_resposta: "Para Deletar", resposta_form: outro_rf, elemento_form: outro_ef2)

      expect {
        delete resposta_elem_path(re)
      }.to change(RespostaElem, :count).by(-1)

      expect(response).to redirect_to(resposta_elems_url)
    end
  end
end
