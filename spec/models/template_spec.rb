require 'rails_helper'

RSpec.describe Template, type: :model do
  before(:each) do
    @admin = Pessoa.create!(usuario: 'neymarjr', nome: 'Neymar Jr', email: 'ney@unb.br', admin: true, password: '123', password_confirmation: '123')
  end

  describe 'Criação e Nested Attributes' do
    context 'Happy Path' do
      it 'cria um template válido associado a uma pessoa' do
        template = Template.new(nome: 'Avaliação de Desempenho', pessoa: @admin)
        
        expect(template).to be_valid
        expect(template.save).to be true
      end

      describe 'Associações' do
        it 'verifica o relacionamento estrutural com template_questoes' do
          template = Template.new(nome: 'Teste Estrutural', pessoa: @admin)
          expect(template.template_questoes).to be_empty
        end
      end

      it 'permite a criação de questões aninhadas (nested attributes) junto com o template' do
        atributos_template = {
          nome: 'Pesquisa de Clima do Vestiário',
          pessoa: @admin,
          template_questoes_attributes: [
            { enunciado: 'Como está as filas do RU?', tipo_resposta: 'texto' },
            { enunciado: 'Nota para a comida do RU', tipo_resposta: 'radio', opcoes: { "1" => "Ruim", "5" => "Ótimo" } }
          ]
        }
        
        template = Template.create!(atributos_template)
        
        expect(template.template_questoes.count).to eq(2)
        expect(template.template_questoes.first.enunciado).to eq('Como está as filas do RU?')
      end
    end


    context 'Sad Path' do
      it 'é inválido tentar criar um template sem o autor (pessoa)' do
        template = Template.new(nome: 'Template Sem Dono')
        
        expect(template).not_to be_valid
        expect(template.errors[:pessoa]).to be_present
      end
    end
  end
end