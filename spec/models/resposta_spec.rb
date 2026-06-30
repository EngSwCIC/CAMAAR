require "rails_helper"

RSpec.describe RespostaFormulario, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:usuario) }
    it { is_expected.to belong_to(:formulario) }
  end

  describe "uniqueness" do
    it "allows creation of a response" do
      formulario = create(:formulario)
      usuario = create(:usuario)

      resposta = create(:resposta_formulario, usuario: usuario, formulario: formulario)
      expect(resposta).to be_persisted
    end
  end

  describe "creation" do
    it "can be created with valid attributes" do
      formulario = create(:formulario)
      usuario = create(:usuario)

      resposta = RespostaFormulario.create!(
        usuario: usuario,
        formulario: formulario,
        data_resposta: Time.current
      )

      expect(resposta).to be_persisted
    end
  end
end
