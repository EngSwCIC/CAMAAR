# frozen_string_literal: true

require "rails_helper"

RSpec.describe Template, type: :model do
  let(:template) do
    described_class.new(
      titulo: "Avaliação de Disciplina",
      descricao: "Template semestral",
      criado_em: Time.current,
      adm_id: 1
    )
  end
  let(:utilizacao_questao) do
    instance_double(UtilizacaoQuestao, marked_for_destruction?: false)
  end
  let(:utilizacao_removida) do
    instance_double(UtilizacaoQuestao, marked_for_destruction?: true)
  end
  let(:adm) do
    double(
      "PerfilAdm",
      destroyed?: false,
      marked_for_destruction?: false,
      new_record?: false,
      valid?: true
    )
  end

  before do
    allow(template)
      .to receive(:adm)
      .and_return(adm)
  end

  describe "associações" do
    it "pertence a um administrador pela chave adm_id" do
      association = described_class.reflect_on_association(:adm)

      expect(association.macro).to eq(:belongs_to)
      expect(association.class_name).to eq("PerfilAdm")
      expect(association.foreign_key).to eq("adm_id")
    end

    it "possui utilizações de questões removidas em cascata" do
      association =
        described_class.reflect_on_association(:utilizacoes_questoes)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("UtilizacaoQuestao")
      expect(association.foreign_key).to eq("template_id")
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it "possui questões através das utilizações" do
      association = described_class.reflect_on_association(:questoes)

      expect(association.macro).to eq(:has_many)
      expect(association.options[:through]).to eq(:utilizacoes_questoes)
      expect(association.options[:source]).to eq(:questao)
    end

    it "possui formulários sem removê-los junto com o template" do
      association = described_class.reflect_on_association(:formularios)

      expect(association.macro).to eq(:has_many)
      expect(association.class_name).to eq("Formulario")
      expect(association.options[:dependent]).to eq(:nullify)
    end
  end

  describe "validações" do
    it "exige título" do
      template.titulo = nil
      simular_utilizacoes(template, [ utilizacao_questao ])

      expect(template).not_to be_valid
      expect(template.errors[:titulo]).not_to be_empty
    end

    it "exige ao menos uma utilização de questão" do
      simular_utilizacoes(template, [])

      expect(template).not_to be_valid
      expect(template.errors[:utilizacoes_questoes])
        .to include("deve conter ao menos uma questão")
    end

    it "ignora utilizações marcadas para remoção" do
      simular_utilizacoes(template, [ utilizacao_removida ])

      expect(template).not_to be_valid
      expect(template.errors[:utilizacoes_questoes])
        .to include("deve conter ao menos uma questão")
    end

    it "é válido com título, administrador e uma questão" do
      simular_utilizacoes(template, [ utilizacao_questao ])

      expect(template).to be_valid
    end

    it "preenche criado_em automaticamente" do
      template.criado_em = nil
      simular_utilizacoes(template, [ utilizacao_questao ])

      template.valid?

      expect(template.criado_em).to be_present
    end

    it "normaliza o título" do
      template.titulo = "  Avaliação de Disciplina  "
      simular_utilizacoes(template, [ utilizacao_questao ])

      template.valid?

      expect(template.titulo).to eq("Avaliação de Disciplina")
    end

    it "limita a descrição a dois mil caracteres" do
      template.descricao = "a" * 2_001
      simular_utilizacoes(template, [ utilizacao_questao ])

      expect(template).not_to be_valid
      expect(template.errors[:descricao]).not_to be_empty
    end
  end

  describe "atributos aninhados" do
    it "remove utilizações de questões marcadas para destruição" do
      template_com_questoes = create_template_with_questoes(
        titulo: "Avaliação com duas questões"
      )
      utilizacao_removida = template_com_questoes.utilizacoes_questoes.first
      questao = utilizacao_removida.questao

      expect do
        template_com_questoes.update!(
          utilizacoes_questoes_attributes: {
            "0" => {
              id: utilizacao_removida.id,
              _destroy: "1"
            }
          }
        )
      end.to change(UtilizacaoQuestao, :count).by(-1)

      expect(UtilizacaoQuestao.exists?(utilizacao_removida.id)).to be(false)
      expect(Questao.exists?(questao.id)).to be(true)
    end

    it "remove opções marcadas para destruição" do
      template_com_questao_objetiva = create_template_with_questoes(
        titulo: "Avaliação objetiva",
        questoes: [
          {
            enunciado: "Como você avalia a disciplina?",
            tipo: :objetiva,
            opcoes: %w[Ruim Regular Bom]
          }
        ]
      )
      utilizacao = template_com_questao_objetiva.utilizacoes_questoes.first
      questao = utilizacao.questao
      opcao_removida = questao.opcoes.first

      expect do
        template_com_questao_objetiva.update!(
          utilizacoes_questoes_attributes: {
            "0" => {
              id: utilizacao.id,
              questao_attributes: {
                id: questao.id,
                opcoes_attributes: {
                  "0" => {
                    id: opcao_removida.id,
                    _destroy: "1"
                  }
                }
              }
            }
          }
        )
      end.to change(Opcao, :count).by(-1)

      expect(Opcao.exists?(opcao_removida.id)).to be(false)
    end
  end

  describe "#criado_por?" do
    it "retorna verdadeiro quando o perfil é o administrador criador" do
      perfil_adm = double("PerfilAdm", id: 1)

      expect(template.criado_por?(perfil_adm)).to be(true)
    end

    it "retorna falso quando o perfil é nil" do
      expect(template.criado_por?(nil)).to be(false)
    end
  end

  def simular_utilizacoes(template, utilizacoes)
    allow(template)
      .to receive(:utilizacoes_questoes)
      .and_return(utilizacoes)
  end
end
