# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Perguntum, type: :model do
  let(:template) { create(:template) }
  
  describe 'associations' do
    it { should belong_to(:template) }
    it { should have_many(:opcoes_pergunta).class_name('OpcoesPerguntum').with_foreign_key('pergunta_id').dependent(:destroy) }
    it { should have_many(:respostas).class_name('Respostum').with_foreign_key('pergunta_id').dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:texto) }
    it { should validate_length_of(:texto).is_at_least(3) }
    it { should validate_presence_of(:tipo) }
    
    it { should define_enum_for(:tipo).with_values(verdadeiro_falso: 0, multipla_escolha: 1, subjetiva: 2) }
  end

  describe 'scopes' do
    let!(:pergunta1) { create(:perguntum, template: template, id: 1) }
    let!(:pergunta3) { create(:perguntum, template: template, id: 3) }
    let!(:pergunta2) { create(:perguntum, template: template, id: 2) }

    describe '.ordenadas' do
      it 'returns perguntas ordered by id' do
        expect(Perguntum.ordenadas).to eq([pergunta1, pergunta2, pergunta3])
      end
    end
  end

  describe 'alias attributes' do
    let(:pergunta) { create(:perguntum, template: template, texto: 'Pergunta teste') }

    it 'aliases titulo to texto' do
      expect(pergunta.titulo).to eq('Pergunta teste')
    end
  end

  describe 'virtual attributes' do
    let(:pergunta) { build(:perguntum, template: template) }

    it 'has ordem attribute accessor' do
      pergunta.ordem = 5
      expect(pergunta.ordem).to eq(5)
    end
  end

  describe '#multipla_escolha_ou_verdadeiro_falso?' do
    context 'when tipo is multipla_escolha' do
      let(:pergunta) { create(:perguntum, template: template, tipo: :multipla_escolha) }

      it 'returns true' do
        expect(pergunta.multipla_escolha_ou_verdadeiro_falso?).to be true
      end
    end

    context 'when tipo is verdadeiro_falso' do
      let(:pergunta) { create(:perguntum, template: template, tipo: :verdadeiro_falso) }

      it 'returns true' do
        expect(pergunta.multipla_escolha_ou_verdadeiro_falso?).to be true
      end
    end

    context 'when tipo is subjetiva' do
      let(:pergunta) { create(:perguntum, template: template, tipo: :subjetiva) }

      it 'returns false' do
        expect(pergunta.multipla_escolha_ou_verdadeiro_falso?).to be false
      end
    end
  end

  describe '#assign_attributes' do
    let(:pergunta) { create(:perguntum, template: template, texto: 'Original') }

    context 'with non-hash attributes' do
      it 'raises ArgumentError for non-hash values' do
        expect { pergunta.assign_attributes('invalid') }.to raise_error(ArgumentError, /must pass a hash/)
      end
    end

    context 'with hash attributes containing titulo' do
      it 'maps titulo to texto' do
        pergunta.assign_attributes(titulo: 'Novo titulo')
        expect(pergunta.texto).to eq('Novo titulo')
      end
    end

    context 'with hash attributes containing ordem' do
      it 'removes ordem from attributes' do
        expect { pergunta.assign_attributes(ordem: 5, texto: 'Novo texto') }.not_to raise_error
        expect(pergunta.texto).to eq('Novo texto')
      end
    end

    context 'with regular attributes' do
      it 'assigns normally' do
        pergunta.assign_attributes(texto: 'Texto normal')
        expect(pergunta.texto).to eq('Texto normal')
      end
    end

    context 'with mixed attributes' do
      it 'handles titulo, ordem and regular attributes correctly' do
        pergunta.assign_attributes(titulo: 'Novo titulo', ordem: 3, tipo: :subjetiva)
        expect(pergunta.texto).to eq('Novo titulo')
        expect(pergunta.tipo).to eq('subjetiva')
      end
    end
  end

  describe '#tipo=' do
    let(:pergunta) { build(:perguntum, template: template) }

    context 'with numeric string values' do
      it 'converts "0" to verdadeiro_falso' do
        pergunta.tipo = '0'
        expect(pergunta.tipo).to eq('verdadeiro_falso')
      end

      it 'converts "1" to multipla_escolha' do
        pergunta.tipo = '1'
        expect(pergunta.tipo).to eq('multipla_escolha')
      end

      it 'converts "2" to subjetiva' do
        pergunta.tipo = '2'
        expect(pergunta.tipo).to eq('subjetiva')
      end

      it 'raises error for invalid numeric strings' do
        expect { pergunta.tipo = '99' }.to raise_error(ArgumentError, /'99' is not a valid tipo/)
      end

      it 'raises error for non-numeric strings' do
        expect { pergunta.tipo = 'abc' }.to raise_error(ArgumentError, /'abc' is not a valid tipo/)
      end
    end

    context 'with integer values' do
      it 'converts 0 to verdadeiro_falso' do
        pergunta.tipo = 0
        expect(pergunta.tipo).to eq('verdadeiro_falso')
      end

      it 'converts 1 to multipla_escolha' do
        pergunta.tipo = 1
        expect(pergunta.tipo).to eq('multipla_escolha')
      end

      it 'converts 2 to subjetiva' do
        pergunta.tipo = 2
        expect(pergunta.tipo).to eq('subjetiva')
      end

      it 'raises error for invalid integers' do
        expect { pergunta.tipo = 99 }.to raise_error(ArgumentError, /'99' is not a valid tipo/)
      end
    end

    context 'with string enum values' do
      it 'assigns verdadeiro_falso directly' do
        pergunta.tipo = 'verdadeiro_falso'
        expect(pergunta.tipo).to eq('verdadeiro_falso')
      end

      it 'assigns multipla_escolha directly' do
        pergunta.tipo = 'multipla_escolha'
        expect(pergunta.tipo).to eq('multipla_escolha')
      end

      it 'assigns subjetiva directly' do
        pergunta.tipo = 'subjetiva'
        expect(pergunta.tipo).to eq('subjetiva')
      end
    end

    context 'with symbol enum values' do
      it 'assigns verdadeiro_falso from symbol' do
        pergunta.tipo = :verdadeiro_falso
        expect(pergunta.tipo).to eq('verdadeiro_falso')
      end

      it 'assigns multipla_escolha from symbol' do
        pergunta.tipo = :multipla_escolha
        expect(pergunta.tipo).to eq('multipla_escolha')
      end

      it 'assigns subjetiva from symbol' do
        pergunta.tipo = :subjetiva
        expect(pergunta.tipo).to eq('subjetiva')
      end
    end
  end

  describe 'database table configuration' do
    it 'uses pergunta table name' do
      expect(Perguntum.table_name).to eq('pergunta')
    end
  end

  describe 'factory creation' do
    it 'creates valid pergunta with template' do
      pergunta = create(:perguntum, template: template)
      expect(pergunta).to be_valid
      expect(pergunta.template).to eq(template)
    end

    it 'creates pergunta with all enum types' do
      pergunta_vf = create(:perguntum, template: template, tipo: :verdadeiro_falso)
      pergunta_me = create(:perguntum, template: template, tipo: :multipla_escolha)
      pergunta_sub = create(:perguntum, template: template, tipo: :subjetiva)
      
      expect(pergunta_vf).to be_verdadeiro_falso
      expect(pergunta_me).to be_multipla_escolha
      expect(pergunta_sub).to be_subjetiva
    end
  end

  describe 'dependent destroy associations' do
    let(:pergunta) { create(:perguntum, template: template) }
    let!(:opcao) { create(:opcoes_perguntum, pergunta: pergunta) }
    let!(:resposta) { create(:respostum, pergunta: pergunta) }

    it 'destroys associated opcoes_pergunta when destroyed' do
      expect { pergunta.destroy }.to change(OpcoesPerguntum, :count).by(-1)
    end

    it 'destroys associated respostas when destroyed' do
      expect { pergunta.destroy }.to change(Respostum, :count).by(-1)
    end
  end
end
