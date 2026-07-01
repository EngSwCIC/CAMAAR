require "rails_helper"

RSpec.describe Departamento, type: :model do
  it "é válido com nome presente" do
    departamento = Departamento.new(nome: "Fábrica de Software")
    expect(departamento).to be_valid
  end

  it "é inválido sem nome" do
    departamento = Departamento.new(nome: nil)
    expect(departamento).not_to be_valid
    expect(departamento.errors[:nome]).to be_present
  end

  it "é inválido com nome duplicado" do
    Departamento.create!(nome: "Engenharia de Software")
    departamento = Departamento.new(nome: "Engenharia de Software")
    expect(departamento).not_to be_valid
    expect(departamento.errors[:nome]).to be_present
  end

  it "possui várias turmas" do
    departamento = Departamento.create!(nome: "Ciência da Computação")
    turma = Turma.create!(departamento: departamento, codigo: "CIC0001", nome: "Algoritmos")

    expect(departamento.turmas).to include(turma)
  end
end
