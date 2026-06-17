require 'rails_helper'

RSpec.describe "Avaliacoes", type: :request do
  let(:admin) { Usuario.create!(nome: "Admin", email: "admin@unb.br", perfil: "administrador", password: "senha", ativo: true) }
  let(:discente) { Usuario.create!(nome: "Discente", email: "discente@unb.br", perfil: "discente", password: "senha", ativo: true) }
  let(:template) { Template.create!(titulo: "Template 1", criador: admin, skip_questions_validation: true) }
  let(:departamento) { Departamento.create!(nome: "DEPTO CIÊNCIAS DA COMPUTAÇÃO") }
  let(:disciplina) { Disciplina.create!(codigo: "CIC0004", nome: "Algoritmos") }
  let(:turma) { Turma.create!(codigo_turma: "Turma A", semestre: "2023.2", disciplina: disciplina, departamento: departamento) }
  let!(:matricula) { Matricula.create!(usuario: discente, turma: turma, papel_na_turma: "aluno") }
  let(:formulario) { Formulario.create!(template: template, turma: turma, criado_por: admin, publico_alvo: "discente", status: "aberto", data_inicio: 1.day.ago, data_limite: 1.day.from_now) }

  before do
    QuestaoTemplate.create!(template: template, enunciado: "Pergunta 1", tipo: "aberta", obrigatoria: true, ordem: 1)
    post login_path, params: { email: discente.email, password: "senha" }
  end

  describe "POST /avaliacoes/:id" do
    it "fails if missing mandatory fields" do
      post responder_avaliacao_path(id: formulario.id), params: {
        respostas: {
          "0" => { texto: "" } # empty response
        }
      }
      expect(response).to redirect_to(responder_avaliacao_path(formulario))
      follow_redirect!
      expect(response.body).to include("Preencha todos os campos obrigatórios")
    end

    it "succeeds with valid data" do
      post responder_avaliacao_path(id: formulario.id), params: {
        respostas: {
          "0" => { texto: "Minha resposta" }
        }
      }
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("Sua avaliação foi enviada com sucesso!")
      expect(Resposta.count).to eq(1)
    end

    it "prevents double submission" do
      Resposta.create!(formulario: formulario, usuario: discente, enviado_em: Time.current)
      
      post responder_avaliacao_path(id: formulario.id), params: {
        respostas: {
          "0" => { texto: "Minha segunda resposta" }
        }
      }
      expect(response).to redirect_to(avaliacoes_path)
      follow_redirect!
      expect(response.body).to include("Você já respondeu a este formulário")
      expect(Resposta.count).to eq(1)
    end
  end
end
