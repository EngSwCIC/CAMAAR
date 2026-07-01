require 'rails_helper'

RSpec.describe Resposta, type: :model do
  let(:template) do
    Template.create!(titulo: 'T1', questoes_attributes: [{ enunciado: 'Q1' }])
  end
  let(:disciplina) { Disciplina.create!(codigo: 'CIC0001', nome: 'Engenharia de Software', department: 'CIC') }
  let(:turma) { Turma.create!(disciplina: disciplina, codigo: 'TA', semestre: '2026.1', horario: '35T45') }
  let(:avaliacao) do
    Avaliacao.create!(template: template, turma: turma, tipo: 'discente',
                      data_inicio: Date.today, data_fim: Date.tomorrow)
  end
  let(:questao) { template.questoes.first }
  let(:user) { User.create!(name: 'Aluno', email: 'aluno@unb.br', password: 'senha123', role: 'user') }

  describe 'validações' do
    it 'é válida com todos os atributos preenchidos' do
      resposta = Resposta.new(user: user, avaliacao: avaliacao, questao: questao, texto: 'Boa aula')
      expect(resposta).to be_valid
    end

    it 'invalida sem texto' do
      resposta = Resposta.new(user: user, avaliacao: avaliacao, questao: questao, texto: nil)
      expect(resposta).not_to be_valid
      expect(resposta.errors[:texto]).to be_present
    end

    it 'invalida duplicata para o mesmo user/avaliacao/questao' do
      Resposta.create!(user: user, avaliacao: avaliacao, questao: questao, texto: 'Primeira')
      duplicata = Resposta.new(user: user, avaliacao: avaliacao, questao: questao, texto: 'Segunda')
      expect(duplicata).not_to be_valid
    end

    it 'permite respostas distintas de usuários diferentes na mesma questão' do
      outro_user = User.create!(name: 'Outro', email: 'outro@unb.br', password: 'senha123', role: 'user')
      Resposta.create!(user: user, avaliacao: avaliacao, questao: questao, texto: 'Resp A')
      resposta2 = Resposta.new(user: outro_user, avaliacao: avaliacao, questao: questao, texto: 'Resp B')
      expect(resposta2).to be_valid
    end
  end

  describe '.salvar_lote' do
    it 'salva todas as respostas válidas' do
      respostas = [Resposta.new(user: user, avaliacao: avaliacao, questao: questao, texto: 'Boa aula')]

      expect {
        expect(described_class.salvar_lote(respostas)).to be(true)
      }.to change(Resposta, :count).by(1)
    end

    it 'retorna falso para submissão vazia' do
      expect(described_class.salvar_lote([])).to be(false)
    end

    it 'não salva quando alguma resposta é inválida' do
      respostas = [Resposta.new(user: user, avaliacao: avaliacao, questao: questao, texto: '')]

      expect {
        expect(described_class.salvar_lote(respostas)).to be(false)
      }.not_to change(Resposta, :count)
    end
  end
end
