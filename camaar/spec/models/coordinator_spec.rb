require 'rails_helper'

RSpec.describe Coordinator, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    admin = create(:admin, :admin1)
    expect(admin).to be_valid
    department = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    expect(coordinator).to be_valid
  end

  it 'é inválido sem FKS existentes' do
    coordinator = build(:coordinator, :coordinator1)
    expect(coordinator).to_not be_valid
  end

  it 'não pode haver atributos repetidos' do
    admin = create(:admin, :admin1)
    expect(admin).to be_valid
    department = create(:department, :departament1)
    coordinator = create(:coordinator, :coordinator1)
    expect(coordinator).to be_valid
    coordinator2 = build(:coordinator, :coordinator1)
    expect(coordinator2).to_not be_valid
  end

  it 'não pode haver atributos essenciais nulos' do
    admin = create(:admin, :admin1)
    expect(admin).to be_valid
    department = create(:department, :departament1)
    coordinator = build(:coordinator, :coordinator1, department_id: nil)
    expect(coordinator).to_not be_valid
    coordinator2 = build(:coordinator, :coordinator1, admin_id: nil)
    expect(coordinator2).to_not be_valid
  end
end
