require "rails_helper"

RSpec.describe Formulario, type: :model do
  describe "turma association" do
    it { is_expected.to belong_to(:turma) }
    it { is_expected.to belong_to(:template_formulario).optional }
    it { is_expected.to belong_to(:criador_formulario) }
  end

  describe "formulario belongs to turma" do
    it "is valid when associated with a turma" do
      formulario = create(:formulario)
      expect(formulario.turma).to be_present
    end

    it "two formularios can be associated with the same turma" do
      turma = create(:turma)
      f1 = create(:formulario, turma: turma, publico_estudante: true)
      f2 = create(:formulario, turma: turma, publico_estudante: false)
      expect(f1.turma).to eq(turma)
      expect(f2.turma).to eq(turma)
    end

    it "a turma can have many formularios" do
      turma = create(:turma)
      f1 = create(:formulario, turma: turma, publico_estudante: true)
      f2 = create(:formulario, turma: turma, publico_estudante: false)
      expect(turma.formularios).to include(f1, f2)
    end
  end
end
