require 'rails_helper'

RSpec.describe TurmaDiscente, type: :model do
  before(:each) do
    #aluno
    pessoa_aluno = Pessoa.create!(usuario: 'neymar', nome: 'Neymar Jr', email: 'ney@unb.br',password: '123', password_confirmation: '123')
    @discente = Discente.create!(pessoa: pessoa_aluno, curso: 'Ciência da Computação', matricula: '10101010')

    #prof e turma
    pessoa_prof = Pessoa.create!(usuario: 'tite', nome: 'Adenor Bachi', email: 'tite@unb.br',password: '123', password_confirmation: '123')
    docente = Docente.create!(pessoa: pessoa_prof, departamento: 'CIC')
    disciplina = Disciplina.create!(codigo: 'CIC0105', nome: 'Engenharia de Software')
    
    @turma = Turma.create!(codigo: 'TA', disciplina: disciplina, docente: docente)
  end

  describe 'Matrícula (Criação e Associações)' do
    context 'Happy Path' do
      it 'vincula um discente a uma turma com sucesso' do
        matricula = TurmaDiscente.new(discente: @discente, turma: @turma, nota: 9.5)
        
        expect(matricula).to be_valid
        expect(matricula.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválido tentar registrar sem um discente' do
        matricula = TurmaDiscente.new(turma: @turma)
        
        expect(matricula).not_to be_valid
        expect(matricula.errors[:discente]).to be_present
      end

      it 'é inválido tentar registrar sem uma turma' do
        matricula = TurmaDiscente.new(discente: @discente)
        
        expect(matricula).not_to be_valid
        expect(matricula.errors[:turma]).to be_present
      end
    end
  end
end