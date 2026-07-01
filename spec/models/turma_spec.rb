require 'rails_helper'

RSpec.describe Turma, type: :model do
  before(:each) do
    @pessoa_tecnico = Pessoa.create!(usuario: 'cr7', nome: 'Cristiano Ronaldo', email: 'papaicris@unb.br', password: '123', password_confirmation: '123')
    @docente = Docente.create!(pessoa: @pessoa_tecnico, departamento: 'Ataque')
    @disciplina = Disciplina.create!(codigo: 'CIC0234', nome: 'PAA')
  end

  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'cria uma turma válida associada a uma disciplina e a um docente' do
        turma = Turma.new(codigo: 'A1', horario: '35T45', semestre: '2026.1', disciplina: @disciplina, docente: @docente)
        
        expect(turma).to be_valid
        expect(turma.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválida ao tentar criar uma turma sem docente' do
        turma = Turma.new(codigo: 'A2', disciplina: @disciplina)
        
        expect(turma).not_to be_valid
        expect(turma.errors[:docente]).to be_present
      end

      it 'é inválida ao tentar criar uma turma sem disciplina' do
        turma = Turma.new(codigo: 'A3', docente: @docente)
        
        expect(turma).not_to be_valid
        expect(turma.errors[:disciplina]).to be_present
      end

      it 'é inválida sem código' do
        turma = Turma.new(codigo: nil)
        expect(turma).not_to be_valid
      end
    end
  end
end