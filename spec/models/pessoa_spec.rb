require 'rails_helper'

RSpec.describe Pessoa, type: :model do
  describe 'Criação e Autenticação' do
    context 'Happy Path' do
      it 'cria uma pessoa válida com senha' do
        pessoa = Pessoa.new(
          usuario: '24103263',
          nome: 'Cristiano Ronaldo',
          email: 'papaicris@unb.br',
          password: 'senha_segura123',
          password_confirmation: 'senha_segura123'
        )
        expect(pessoa).to be_valid
        expect(pessoa.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválida se as senhas informadas não conferem' do
        pessoa = Pessoa.new(
          usuario: '24103263',
          nome: 'Cristiano Ronaldo',
          email: 'papaicris@unb.br',
          password: 'senha_segura123',
          password_confirmation: 'senha_errada456'
        )
        expect(pessoa).not_to be_valid
        expect(pessoa.errors[:password_confirmation]).to be_present
      end

      it 'é inválida sem preencher a senha inicial' do
        pessoa = Pessoa.new(usuario: '123456', nome: 'Teste', email: 'teste@unb.br')
        expect(pessoa).not_to be_valid
        expect(pessoa.errors[:password]).to be_present
      end
      
      it 'é inválida sem um e-mail cadastrado' do
        pessoa = Pessoa.new(usuario: '112233', nome: 'Teste E-mail', password: '123', password_confirmation: '123')
        expect(pessoa).not_to be_valid
        expect(pessoa.errors[:email]).to be_present
      end
    end
  end

  describe 'Associações' do
    context 'Happy Path' do
      it 'pode ter um discente associado' do
        pessoa = Pessoa.create!(usuario: '12345', email: 'aluno@unb.br', password: '123', password_confirmation: '123')
        discente = Discente.create!(pessoa: pessoa, matricula: '12345')
        
        expect(pessoa.reload.discente).to eq(discente)
      end

      it 'pode ter um docente associado' do
        pessoa = Pessoa.create!(usuario: '67890', email: 'docente@unb.br', password: '123', password_confirmation: '123')
        docente = Docente.create!(pessoa: pessoa, departamento: 'CIC')
        
        expect(pessoa.reload.docente).to eq(docente)
      end
    end
  end
end