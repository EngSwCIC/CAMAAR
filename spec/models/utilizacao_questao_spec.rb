# frozen_string_literal: true

require "rails_helper"

RSpec.describe UtilizacaoQuestao, type: :model do
  describe "associações" do
    it "pertence a um template" do
      association = described_class.reflect_on_association(:template)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Template")
      expect(association.foreign_key).to eq("template_id")
    end

    it "pertence a uma questão" do
      association = described_class.reflect_on_association(:questao)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("Questao")
      expect(association.foreign_key).to eq("questao_id")
    end

    it "pode pertencer a outra utilização de questão como parent" do
      association = described_class.reflect_on_association(:parent)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("UtilizacaoQuestao")
      expect(association.foreign_key).to eq("parent_id")
      expect(association.options[:optional]).to be(true)
    end

    it "possui children removidos em cascata" do
      association = described_class.reflect_on_association(:children)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("UtilizacaoQuestao")
      expect(association.foreign_key).to eq("parent_id")
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "expõe opções através da questão" do
      association = described_class.reflect_on_association(:opcoes)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:questao)
      expect(association.options[:source]).to eq(:opcoes)
    end
  end

  describe "validações" do
    it "exige template" do
      validator = presence_validator_for(:template)

      expect(validator).to be_present
    end

    it "exige questão" do
      validator = presence_validator_for(:questao)

      expect(validator).to be_present
    end

    it "exige número inteiro e positivo" do
      validators = described_class.validators_on(:numero)

      expect(validators.map(&:kind)).to include(:presence, :numericality)
      expect(numericality_validator_for(:numero).options)
        .to include(only_integer: true, greater_than: 0)
    end

    it "mantém número único por template e parent" do
      validator = uniqueness_validator_for(:numero)

      expect(validator.options[:scope]).to eq(%i[template_id parent_id])
    end

    it "herda o template do parent quando não informado" do
      template = create_template_with_questoes(titulo: "Avaliação")
      parent = template.utilizacoes_questoes.first
      questao_filha = Questao.create!(enunciado: "Explique", tipo: :discursiva)
      utilizacao = described_class.new(parent: parent, questao: questao_filha, numero: 2)

      expect(utilizacao).to be_valid
      expect(utilizacao.template).to eq(template)
    end

    it "rejeita parent de outro template" do
      template = create_template_with_questoes(titulo: "Avaliação")
      outro_template = create_template_with_questoes(titulo: "Outra avaliação")
      parent_externo = outro_template.utilizacoes_questoes.first
      questao_filha = Questao.create!(enunciado: "Explique", tipo: :discursiva)
      utilizacao = described_class.new(
        template: template,
        parent: parent_externo,
        questao: questao_filha,
        numero: 2
      )

      expect(utilizacao).not_to be_valid
      expect(utilizacao.errors[:parent]).to include("deve pertencer ao mesmo template")
    end

    it "rejeita parent apontando para o próprio registro" do
      template = create_template_with_questoes(titulo: "Avaliação")
      utilizacao = template.utilizacoes_questoes.first

      utilizacao.parent_id = utilizacao.id

      expect(utilizacao).not_to be_valid
      expect(utilizacao.errors[:parent]).to include("não pode ser a própria utilização de questão")
    end

    it "rejeita ciclos na hierarquia de questões" do
      template = create_template_with_questoes(titulo: "Avaliação")
      parent = template.utilizacoes_questoes.first
      questao_filha = Questao.create!(enunciado: "Explique", tipo: :discursiva)
      child = described_class.create!(
        template: template,
        parent: parent,
        questao: questao_filha,
        numero: 2
      )

      parent.parent = child

      expect(parent).not_to be_valid
      expect(parent.errors[:parent]).to include("não pode formar ciclo")
    end
  end

  describe "#raiz?" do
    it "retorna verdadeiro quando não há parent" do
      utilizacao = described_class.new(parent_id: nil)

      expect(utilizacao).to be_raiz
    end

    it "retorna falso quando há parent" do
      utilizacao = described_class.new(parent_id: 1)

      expect(utilizacao).not_to be_raiz
    end
  end

  def presence_validator_for(attribute)
    described_class.validators_on(attribute).find { |validator| validator.kind == :presence }
  end

  def numericality_validator_for(attribute)
    described_class.validators_on(attribute).find { |validator| validator.kind == :numericality }
  end

  def uniqueness_validator_for(attribute)
    described_class.validators_on(attribute).find { |validator| validator.kind == :uniqueness }
  end
end
