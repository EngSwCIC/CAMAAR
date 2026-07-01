require "rails_helper"

RSpec.describe Turma, type: :model do
  let(:departamento) { Departamento.create!(nome: "Fábrica de Software") }

  it "é válida com codigo, nome e departamento" do
    turma = Turma.new(departamento: departamento, codigo: "FGA0001", nome: "Engenharia de Software")
    expect(turma).to be_valid
  end

  it "é inválida sem codigo" do
    turma = Turma.new(departamento: departamento, codigo: nil, nome: "Engenharia de Software")
    expect(turma).not_to be_valid
    expect(turma.errors[:codigo]).to be_present
  end

  it "é inválida sem nome" do
    turma = Turma.new(departamento: departamento, codigo: "FGA0001", nome: nil)
    expect(turma).not_to be_valid
    expect(turma.errors[:nome]).to be_present
  end

  it "é inválida sem departamento" do
    turma = Turma.new(departamento: nil, codigo: "FGA0001", nome: "Engenharia de Software")
    expect(turma).not_to be_valid
  end
end
