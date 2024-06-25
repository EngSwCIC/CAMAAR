require 'rails_helper'

RSpec.describe Matricula, type: :model do
  context "para validar uma matricula" do
    it "deve pertencer a um usuário" do
      matricula = Matricula.reflect_on_association(:user)
      expect(matricula.macro).to eq(:belongs_to)
    end

    it "deve pertencer a uma turma" do
      matricula = Matricula.reflect_on_association(:turma)
      expect(matricula.macro).to eq(:belongs_to)
    end
  end
end
