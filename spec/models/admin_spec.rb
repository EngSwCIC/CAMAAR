require "rails_helper"

RSpec.describe Admin, type: :model do
  let(:user) do
    User.create!(nome: "Docente Teste", email: "docente@camaar.com", matricula: "202400050", perfil: "Administrador")
  end

  let(:departamento) { Departamento.create!(nome: "Fábrica de Software") }
  let(:outro_departamento) { Departamento.create!(nome: "Engenharia Elétrica") }

  it "é válido com user e departamento" do
    admin = Admin.new(user: user, departamento: departamento)
    expect(admin).to be_valid
  end

  it "é inválido sem user" do
    admin = Admin.new(user: nil, departamento: departamento)
    expect(admin).not_to be_valid
  end

  it "é inválido sem departamento" do
    admin = Admin.new(user: user, departamento: nil)
    expect(admin).not_to be_valid
  end

  it "não permite o mesmo usuário duas vezes no mesmo departamento" do
    Admin.create!(user: user, departamento: departamento)
    duplicado = Admin.new(user: user, departamento: departamento)

    expect(duplicado).not_to be_valid
    expect(duplicado.errors[:user_id]).to be_present
  end

  it "permite o mesmo usuário em departamentos diferentes (1 docente para N departamentos)" do
    Admin.create!(user: user, departamento: departamento)
    em_outro_departamento = Admin.new(user: user, departamento: outro_departamento)

    expect(em_outro_departamento).to be_valid
  end
end
