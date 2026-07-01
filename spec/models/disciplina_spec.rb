require 'rails_helper'

RSpec.describe Disciplina, type: :model do
  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'cria e persiste uma disciplina válida expondo suas propriedades' do
        disciplina = Disciplina.create!(codigo: 'CIC0097', nome: 'Bancos de Dados')
        
        expect(disciplina.codigo).to eq('CIC0097')
        expect(disciplina.nome).to eq('Bancos de Dados')
      end
    end
  end
end