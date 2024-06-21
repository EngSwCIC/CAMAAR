require 'rails_helper'

RSpec.describe Department, type: :model do
  it 'é inválido com constraints duplicadas' do
    department = create(:department, :departament1)
    department2 = build(:department, :departament1)
    expect(department2).to_not be_valid
  end

  it 'é válido com atributos válidos e FKS existentes' do
    department = build(:department, :departament1)
    expect(department).to be_valid
  end
end
