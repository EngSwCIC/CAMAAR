require 'rails_helper'

RSpec.describe Avaliacao, type: :model do
  let(:template) do
    Template.create!(titulo: 'Padrão', questoes_attributes: [{ enunciado: 'Q1' }])
  end
  let(:disciplina) { Disciplina.create!(codigo: 'CIC0001', nome: 'Engenharia de Software', department: 'CIC') }
  let(:turma) { Turma.create!(disciplina: disciplina, codigo: 'TA', semestre: '2026.1', horario: '35T45') }
  let(:admin) { User.create!(name: 'Admin', email: 'admin-model@unb.br', password: 'senha123', role: 'admin') }
  let(:aluno) { User.create!(name: 'Aluno', email: 'aluno-model@unb.br', password: 'senha123', role: 'user') }
  let(:avaliacao) do
    Avaliacao.create!(template: template, turma: turma, tipo: 'discente',
                      data_inicio: Date.today, data_fim: Date.tomorrow)
  end

  describe 'Validações de Domínio' do
    it 'invalida o registro sem um template associado' do
      avaliacao = Avaliacao.new(turma: turma, tipo: 'discente', data_inicio: Date.today, data_fim: Date.tomorrow)
      expect(avaliacao).not_to be_valid
    end

    it 'invalida o registro se a data de fim for anterior à data de início' do
      avaliacao = Avaliacao.new(template: template, turma: turma, tipo: 'discente',
                                data_inicio: Date.tomorrow, data_fim: Date.today)

      expect(avaliacao).not_to be_valid
      expect(avaliacao.errors[:data_fim]).to include('deve ser posterior à data de início')
    end
  end

  describe '.visiveis_para' do
    it 'retorna todos os formulários para administradores' do
      docente = Avaliacao.create!(template: template, turma: turma, tipo: 'docente',
                                  data_inicio: Date.today, data_fim: Date.tomorrow)

      expect(described_class.visiveis_para(admin)).to contain_exactly(avaliacao, docente)
    end

    it 'retorna apenas formulários discentes pendentes das turmas do aluno' do
      TurmaAluno.create!(turma: turma, aluno_id: aluno.id)
      respondida = Avaliacao.create!(template: template, turma: turma, tipo: 'discente',
                                     data_inicio: Date.today, data_fim: Date.tomorrow)
      Avaliacao.create!(template: template, turma: turma, tipo: 'docente',
                        data_inicio: Date.today, data_fim: Date.tomorrow)
      Resposta.create!(user: aluno, avaliacao: respondida,
                       questao: template.questoes.first, texto: 'Respondida')

      expect(described_class.visiveis_para(aluno)).to contain_exactly(avaliacao)
    end
  end

  describe '#respondida_por?' do
    it 'indica se o usuário já respondeu a avaliação' do
      expect(avaliacao.respondida_por?(aluno)).to be(false)

      Resposta.create!(user: aluno, avaliacao: avaliacao,
                       questao: template.questoes.first, texto: 'Respondida')

      expect(avaliacao.respondida_por?(aluno)).to be(true)
    end
  end

  describe '#total_respondentes' do
    it 'conta usuários distintos que responderam a avaliação' do
      outro_aluno = User.create!(name: 'Outro', email: 'outro-model@unb.br', password: 'senha123', role: 'user')
      questao = template.questoes.first
      Resposta.create!(user: aluno, avaliacao: avaliacao, questao: questao, texto: 'Boa')
      Resposta.create!(user: outro_aluno, avaliacao: avaliacao, questao: questao, texto: 'Regular')

      expect(avaliacao.total_respondentes).to eq(2)
    end
  end

  describe '#questoes_com_respostas' do
    it 'retorna as questões do template' do
      expect(avaliacao.questoes_com_respostas).to contain_exactly(template.questoes.first)
    end
  end
end
