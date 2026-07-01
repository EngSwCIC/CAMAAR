require 'rails_helper'

RSpec.describe Discente, type: :model do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: 'vinijr', nome: 'Vinícius Júnior', email: 'vini@unb.br', password: '123', password_confirmation: '123')
  end

  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'cria um discente válido associado a uma pessoa' do
        discente = Discente.new(curso: 'Ciência da Computação', matricula: '202020202', pessoa: @pessoa)
        
        expect(discente).to be_valid
        expect(discente.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválido sem uma pessoa associada' do
        discente = Discente.new(curso: 'Engenharia de Computação', matricula: '190000000')
        
        expect(discente).not_to be_valid
        expect(discente.errors[:pessoa]).to be_present
      end
    end
  end
end