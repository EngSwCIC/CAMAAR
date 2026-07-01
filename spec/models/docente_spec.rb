require 'rails_helper'

RSpec.describe Docente, type: :model do
  before(:each) do
    # Thiago Silva dando aula de Lógica
    @pessoa = Pessoa.create!(usuario: 'thiagosilva', nome: 'Thiago Silva', email: 'thiago@unb.br', password: '123', password_confirmation: '123')
  end

  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'cria um docente válido associado a uma pessoa' do
        docente = Docente.new(departamento: 'Departamento de Ciência da Computação (CIC)', pessoa: @pessoa)
        
        expect(docente).to be_valid
        expect(docente.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválido sem uma pessoa associada' do
        docente = Docente.new(departamento: 'Matemática (MAT)')
        
        expect(docente).not_to be_valid
        expect(docente.errors[:pessoa]).to be_present
      end
    end
  end
end