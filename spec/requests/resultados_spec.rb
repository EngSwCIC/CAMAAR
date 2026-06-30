require 'rails_helper'

RSpec.describe "Resultados", type: :request do
  let(:turma)    { Turma.create!(code: "RES1", class_code: "A", semester: "2026.1", name: "Materia Res") }
  let(:template) { Template.create!(nome: "Template Res") }
  let!(:question) { Question.create!(template: template, enunciado: "Como foi?", tipo: "discursiva") }
  let(:formulario) { Formulario.create!(template: template, turma: turma, titulo: "Avaliacao Final") }
  let(:aluno) { User.create!(email: "aluno_res@unb.br", password: "password123", nome: "Aluno", matricula: "771", perfil: "discente") }

  # slug = downcase, espaços/pontos viram "_", remove o que não for [a-z0-9_]
  let(:slug) { "avaliacao_final" }

  describe "GET /resultados/:slug" do
    it "exibe a página de resultados quando o formulário existe (Happy Path)" do
      formulario
      get "/resultados/#{slug}"
      expect(response).to have_http_status(:success)
    end

    it "retorna 404 quando o slug não corresponde a nenhum formulário (Sad Path)" do
      get "/resultados/inexistente"
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /resultados/:slug/download" do
    it "baixa o CSV quando há respostas (Happy Path)" do
      Resposta.create!(formulario: formulario, user: aluno, question_id: question.id, valor: "Muito bom")
      get "/resultados/#{slug}/download"

      expect(response).to have_http_status(:success)
      expect(response.headers["Content-Type"]).to include("text/csv")
      expect(response.body).to include("Muito bom")
    end

    it "avisa quando não há respostas para exportar (Sad Path)" do
      formulario
      get "/resultados/#{slug}/download"
      expect(response.body).to include("Não há respostas para exportar")
    end

    it "retorna 404 quando o formulário não existe (Sad Path)" do
      get "/resultados/inexistente/download"
      expect(response).to have_http_status(:not_found)
    end
  end
end
