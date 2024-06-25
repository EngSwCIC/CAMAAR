require 'rails_helper'

RSpec.describe Materia, type: :model do
  describe "para que seja válida" do
    it "deve ser válida :)" do
      materia = create(:materia)
      expect(materia).to be_valid
    end
=begin
    it "deve possuir um nome" do
      materiaB = build(:materia, nome: nil)
      expect(materiaB).to_not be_valid
    end
=end
    it "deve possuir um código" do
      materiaB = build(:materia, codigo: nil)
      expect(materiaB).to_not be_valid
    end
    it "o código deve ser válido" do
      materia = create(:materia)
      expect(materia.codigo).to match(/\A[A-Z]{3}[0-9]{4}\z/)
    end
  end

  describe "para ter relações válidas" do
    it "pode ter várias turmas" do
      materia = Materia.reflect_on_association(:turmas)
      expect(materia.macro).to eq(:has_many)
    end
  end
end
