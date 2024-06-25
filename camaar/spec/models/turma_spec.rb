require 'rails_helper'

RSpec.describe Turma, type: :model do
  describe "para que seja válida" do
    it "deve ser válida :)" do
      turma = create(:turma)
      expect(turma).to be_valid
    end

    it "deve possuir um código" do
      turmaB = build(:turma, codigo: nil)
      expect(turmaB).to_not be_valid
    end
    it "o código deve ser válido" do
      turma = create(:turma)
      expect(turma.codigo).to match(/\A[A-Z]{2}\z/)
    end

    it "deve possuir um semestre" do
      turmaB = build(:turma, semestre: nil)
      expect(turmaB).to_not be_valid
    end
    it "o semestre deve ser válido" do
      turma = create(:turma)
      expect(turma.semestre).to match(/\A[0-9]{4}\.[1-2]\z/)
    end
=begin
    it "deve possuir um horário" do
      turmaB = build(:turma, horario: nil)
      expect(turmaB).to_not be_valid
    end
=end
    it "o horário deve ser válido" do
      turma = create(:turma)
      expect(turma.horario).to match(/\A[0-9]{2}[T|N|M][0-9]{2}\z/)
    end

    it "deve pertencer a uma matéria" do
      turma = create(:turma)
      expect(turma.materia).to be_kind_of(Materia)
    end
  end

  describe "para ter relações válidas" do
    it "deve ter um formulário" do
      turma = Turma.reflect_on_association(:formulario)
      expect(turma.macro).to eq(:has_one)
    end

    it "pode ter várias matrículas" do
      turma = Turma.reflect_on_association(:matriculas)
      expect(turma.macro).to eq(:has_many)
    end

    it "pode ter vários usuários" do
      turma = Turma.reflect_on_association(:users)
      expect(turma.macro).to eq(:has_many)
    end
  end
end
