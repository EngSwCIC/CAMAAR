require 'rails_helper'

RSpec.describe "Resultados", type: :request do
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
  end

  describe "GET /resultados/:id/export_csv" do
    it "denies access to non-admins" do
      post login_path, params: { email: discente.email, password: "senha" }
      get export_csv_resultado_path(id: formulario.id)
      expect(response).to redirect_to("/")
      expect(flash[:alert]).to include("Acesso negado")
    end

    it "redirects if there are no responses" do
      post login_path, params: { email: admin.email, password: "senha" }
      get export_csv_resultado_path(id: formulario.id)
      expect(response).to redirect_to(admin_relatorios_path)
      expect(flash[:alert]).to include("Não há dados suficientes")
    end

    it "exports CSV if there are responses" do
      post login_path, params: { email: admin.email, password: "senha" }
      
      resposta = Resposta.create!(formulario: formulario, usuario: discente, enviado_em: Time.current)
      RespostaItem.create!(resposta: resposta, questao_template: template.perguntas.first, valor_texto: "Resposta teste")
      
      get export_csv_resultado_path(id: formulario.id)
      
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include("filename=")
      
      csv_content = response.body
      expect(csv_content).to include("Matrícula,Turma,Disciplina,Respostas")
      expect(csv_content).to include("Anônimo") # Because student doesn't have matricula string
      expect(csv_content).to include("Turma A")
      expect(csv_content).to include("Algoritmos")
      expect(csv_content).to include("Resposta teste")
    end
  end
end
