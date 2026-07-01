require 'rails_helper'

RSpec.describe Questao, type: :model do
  before(:each) do
    @pessoa = Pessoa.create!(usuario: 'zidane', nome: 'Zinedine Zidane', email: 'zidane@unb.br', password: '123', password_confirmation: '123')
    @docente = Docente.create!(pessoa: @pessoa)
    @disciplina = Disciplina.create!(codigo: 'CIC002', nome: 'FTC')
    @turma = Turma.create!(codigo: 'B1', disciplina: @disciplina, docente: @docente)
    
    @template = Template.create!(nome: 'Template Questao Spec', pessoa: @pessoa)
    @formulario = Formulario.create!(turma: @turma, template: @template, status: :aberto)
  end

  describe 'Criação e Serialização' do
    context 'Happy Path' do
      it 'cria uma questão do tipo texto válida' do
        questao = Questao.new(formulario: @formulario, enunciado: 'O que é uma porta lógica?', tipo_resposta: :texto)
        
        expect(questao).to be_valid
        expect(questao.save).to be true
        expect(questao.texto?).to be true
      end

      it 'cria uma questão do tipo radio e salva as opções como JSON corretamente' do
        opcoes_json = { "1" => "AND", "2" => "OR", "3" => "XOR" }
        questao = Questao.new(formulario: @formulario, enunciado: 'Qual porta lógica é a que implementa a operação conjunção?', tipo_resposta: :radio, opcoes: opcoes_json)
        
        expect(questao).to be_valid
        expect(questao.save).to be true
        
        #recarregando do banco
        questao_salva = Questao.find(questao.id)
        expect(questao_salva.opcoes["1"]).to eq("AND")
      end
    end

    context 'Sad Path' do
      it 'é inválida sem um formulário associado' do
        questao = Questao.new(enunciado: 'Pergunta solta', tipo_resposta: :texto)
        
        expect(questao).not_to be_valid
        expect(questao.errors[:formulario]).to be_present
      end
    end
  end
end