require 'rails_helper'

RSpec.describe "Exportação CSV", type: :request do
  let(:admin) do
    User.create!(
      name: "Admin",
      email: "admin@unb.br",
      matricula: "1",
      role: "admin",
      password: "123456"
    )
  end

  before do
    sign_in admin
  end

  let!(:template) do
    Template.create!(titulo: "Avaliação Docente",
        questoes_attributes: [
        { 
            enunciado: "Como avalia a disciplina?" 
        }
    ])

  end

  let!(:questao) do
    template.questoes.first
  end

  let!(:disciplina) do
    Disciplina.create!(
      codigo: "CIC0097",
      nome: "Banco de Dados",
      department: "CIC"
    )
  end

  let!(:turma) do
    Turma.create!(
      codigo: "TA",
      semestre: "2026.1",
      horario: "35T45",
      disciplina: disciplina
    )
  end

  let!(:avaliacao) do
    Avaliacao.create!(
      template: template,
      turma: turma,
      data_inicio: Date.today,
      data_fim: Date.today + 7.days
    )
  end

    context 'quando existem respostas' do

    before do
      aluno = User.create!(
        name: "João",
        email: "joao@unb.br",
        matricula: "2",
        role: "user",
        password: "123456"
      )

      Resposta.create!(
        user: aluno,
        avaliacao: avaliacao,
        questao: questao,
        texto: "Excelente"
      )
    end

    it 'gera o csv' do
      get exportar_csv_avaliacao_path(avaliacao)

      expect(response).to have_http_status(:success)
      expect(response.content_type).to include('text/csv')
    end
  end

    context 'quando não existem respostas' do

    it 'não gera o arquivo e redireciona' do
      get exportar_csv_avaliacao_path(avaliacao)

      expect(response).to redirect_to(
        resultados_avaliacao_path(avaliacao)
      )

      follow_redirect!

      expect(response.body)
        .to include('Não existem respostas para exportar')
    end
  end
end