require "rails_helper"

RSpec.describe Formulario, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:turma) }
    it { is_expected.to belong_to(:criador_formulario) }
    it { is_expected.to have_many(:resposta_formularios) }
    it { is_expected.to have_many(:pergunta_formularios) }
  end

  describe "creation" do
    it "can be saved without validations for general use" do
      formulario = create(:formulario)
      expect(formulario).to be_persisted
    end

    it "is associated with a turma" do
      formulario = create(:formulario)
      expect(formulario.turma).to be_present
    end
  end

  describe "resposta_formularios" do
    let(:formulario) { create(:formulario) }

    it "starts with no responses" do
      expect(formulario.resposta_formularios.count).to eq(0)
    end

    it "can have responses registered" do
      usuario = create(:usuario)
      RespostaFormulario.create!(
        formulario: formulario,
        usuario: usuario,
        data_resposta: Time.current
      )
      expect(formulario.resposta_formularios.count).to eq(1)
    end
  end
end
