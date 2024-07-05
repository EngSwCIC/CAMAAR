require 'rails_helper'

RSpec.describe Turma, type: :model do
    describe "valid turma" do
    let(:professor) { User.create(nome: "John Doe") }
    let(:materia) { Materia.create(nome: "Matemática") }

    it "is not valid without a professor" do
        turma = Turma.new(materia_id: materia.id)
        expect(turma).not_to be_valid
    end

    it "is not valid without a materia" do
        turma = Turma.new(id_professor: professor.id)
        expect(turma).not_to be_valid
    end
    end
end
