require 'rails_helper'

RSpec.describe "Admin::Resultados", type: :request do
  before(:each) do
    @admin = Pessoa.create!(
      usuario: 'alisson', email: 'alisson@unb.br', nome: 'Alisson Becker', 
      password: '123', password_confirmation: '123', admin: true
    )
    post login_path, params: { login: 'alisson@unb.br', password: '123' }

    @docente = Docente.create!(pessoa: @admin)
    @disciplina = Disciplina.create!(codigo: 'CIC0202', nome: 'Programação Concorrente')
    @turma = Turma.create!(codigo: 'TA', disciplina: @disciplina, docente: @docente)
    
    @template = Template.create!(nome: 'Avaliação da Disciplina', pessoa: @admin)
    @formulario = Formulario.create!(turma: @turma, template: @template, status: :fechado)
    @questao = Questao.create!(formulario: @formulario, enunciado: 'Como foi o semestre?', tipo_resposta: :texto)
    
    @pessoa_aluno = Pessoa.create!(
      usuario: 'robertocarlos', email: 'rcarlos@unb.br', nome: 'Roberto Carlos', 
      password: '123', password_confirmation: '123'
    )
    @discente = Discente.create!(pessoa: @pessoa_aluno, matricula: '999888777')
    Resposta.create!(questao: @questao, discente: @discente, conteudo: 'Achei a matéria pesada, mas aprendi muito.')
  end

  describe "GET /admin/resultados" do
    it "carrega a listagem de resultados com sucesso" do
      get admin_resultados_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/resultados/:id" do
    it "carrega a página de resultados de um formulário específico" do
      get admin_resultado_path(@formulario)
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin/resultados/:id/exportar_csv" do
    it "gera o download do arquivo CSV com as respostas preenchidas" do
      get exportar_csv_admin_resultado_path(@formulario)
      
      expect(response).to have_http_status(:success)
      expect(response.content_type).to eq('text/csv')
      expect(response.headers['Content-Disposition']).to include("relatorio_turma_#{@formulario.turma.codigo}.csv")
      
      expect(response.body).to include('Roberto Carlos')
      expect(response.body).to include('Achei a matéria pesada, mas aprendi muito.')
    end

    context "quando o formulário possui questões do tipo rádio" do
      it "exporta o CSV convertendo os mapeamentos de opções com sucesso" do
        formulario_radio = Formulario.create!(turma: @turma, template: @template, status: :fechado)
        questao_radio = Questao.create!(
          formulario: formulario_radio, 
          enunciado: 'Classifique a matéria:', 
          tipo_resposta: :radio, 
          opcoes: { "1" => "Fácil", "5" => "Difícil" }
        )
        Resposta.create!(questao: questao_radio, discente: @discente, conteudo: '5')

        get exportar_csv_admin_resultado_path(formulario_radio)
        expect(response).to have_http_status(:success)
      end
    end

    context "quando o formulário não possui nenhuma resposta registrada" do
      it "gera a estrutura e o cabeçalho do CSV vazios sem quebrar" do
        formulario_vazio = Formulario.create!(turma: @turma, template: @template, status: :fechado)
        Questao.create!(formulario: formulario_vazio, enunciado: 'Pergunta sem resposta', tipo_resposta: :texto)

        get exportar_csv_admin_resultado_path(formulario_vazio)
        expect(response).to have_http_status(:success)
      end
    end
  end
end