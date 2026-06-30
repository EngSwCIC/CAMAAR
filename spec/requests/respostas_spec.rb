require 'rails_helper'

RSpec.describe "Respostas", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:aluno) { User.create!(email: "aluno@unb.br", password: "password123", nome: "Aluno Teste", matricula: "111111", perfil: "discente") }
  let(:turma) { Turma.create!(code: "123", class_code: "A", semester: "2026.1", name: "Materia Teste") }
  let(:template) { Template.create!(nome: "Avaliação Padrão") }
  
  let(:formulario) { Formulario.create!(template: template, turma_id: turma.id, titulo: "Formulário 1") }
  
  let!(:q1) { Question.create!(template: template, enunciado: "Questão 1", tipo: "discursiva") }
  let!(:q2) { Question.create!(template: template, enunciado: "Questão 2", tipo: "discursiva") }

  before do
    sign_in aluno
  end

  describe "POST /formularios/:formulario_id/respostas" do
    
    context "1. Quando o usuário não está matriculado na turma" do
      it "bloqueia o acesso e redireciona (Sad Path)" do
        post "/formularios/#{formulario.id}/respostas", params: { respostas: { q1.id.to_s => "R1" } }

        expect(response).to redirect_to(formularios_path)
        expect(flash[:alert]).to eq("Você não está matriculado nesta turma.")
      end
    end

    context "Quando o usuário está devidamente matriculado" do
      before do
        Enrollment.create!(user: aluno, turma: turma, role: "discente")
      end

      context "2. E tenta responder o mesmo formulário duas vezes" do
        before do
          Resposta.create!(formulario: formulario, user: aluno, question_id: q1.id, valor: "Resposta Antiga")
        end

        it "bloqueia a duplicidade e redireciona (Sad Path)" do
          post "/formularios/#{formulario.id}/respostas", params: { respostas: { q1.id.to_s => "Nova Tentativa" } }

          expect(response).to redirect_to(formularios_path)
          expect(flash[:alert]).to eq("Você já respondeu este formulário.")
        end
      end

      context "3. E envia menos respostas do que o número de questões" do
        it "recusa o formulário por estar incompleto e redireciona (Sad Path)" do
          post "/formularios/#{formulario.id}/respostas", params: { respostas: { q1.id.to_s => "Só sei essa" } }

          expect(response).to redirect_to(formulario_path(formulario))
          expect(flash[:alert]).to eq("Existem questões obrigatórias não respondidas.")
        end
      end

      context "4. E ocorre um erro interno ao salvar no banco" do
        it "cai no bloco rescue e avisa o usuário (Sad Path)" do
          allow(Resposta).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Resposta.new))

          post "/formularios/#{formulario.id}/respostas", params: {
            respostas: { q1.id.to_s => "R1", q2.id.to_s => "R2" }
          }

          expect(response).to redirect_to(formulario_path(formulario))
          expect(flash[:alert]).to match(/Erro ao enviar respostas:/)
        end
      end
    end
  end
end