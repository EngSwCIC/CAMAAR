require 'rails_helper'

RSpec.describe Resposta, type: :model do
  before(:each) do
    #formulario
    @pessoa_docente = Pessoa.create!(usuario: 'pep', nome: 'Pep Guardiola', email: 'pep@unb.br', password: '123', password_confirmation: '123')
    docente = Docente.create!(pessoa: @pessoa_docente)
    disciplina = Disciplina.create!(codigo: 'CIC0234', nome: 'PAA')
    turma = Turma.create!(codigo: 'C1', disciplina: disciplina, docente: docente)
    
    template = Template.create!(nome: 'Template Resposta Spec', pessoa: @pessoa_docente)
    formulario = Formulario.create!(turma: turma, template: template, status: :aberto)
    @questao = Questao.create!(formulario: formulario, enunciado: 'O que é a notação big O?', tipo_resposta: :texto)
    #aluno
    @pessoa_aluno = Pessoa.create!(usuario: 'messi', nome: 'Lionel Messi',email: 'messi@unb.br', password: '123', password_confirmation: '123')
    @discente = Discente.create!(pessoa: @pessoa_aluno, matricula: '101010')
  end

  describe 'Criação e Associações' do
    context 'Happy Path' do
      it 'registra uma resposta válida para uma questão por um discente' do
        resposta = Resposta.new(questao: @questao, discente: @discente, conteudo: 'Achei o esquema muito ofensivo e eficiente.')
        
        expect(resposta).to be_valid
        expect(resposta.save).to be true
      end
    end

    context 'Sad Path' do
      it 'é inválida se não estiver associada a uma questão' do
        resposta = Resposta.new(discente: @discente, conteudo: 'Resposta sem pergunta.')
        
        expect(resposta).not_to be_valid
        expect(resposta.errors[:questao]).to be_present
      end

      it 'é inválida se não estiver associada a um discente' do
        resposta = Resposta.new(questao: @questao, conteudo: 'Resposta anônima não permitida.')
        
        expect(resposta).not_to be_valid
        expect(resposta.errors[:discente]).to be_present
      end
    end
  end
end