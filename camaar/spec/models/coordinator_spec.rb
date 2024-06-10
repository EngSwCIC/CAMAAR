require 'rails_helper'

RSpec.describe Coordinator, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    admin = create(:admin)
    expect(admin).to be_valid
    department = create(:department)
    coordinator = create(:coordinator)
    expect(coordinator).to be_valid
  end

  it 'é inválido sem FKS existentes' do
    coordinator = build(:coordinator)
    expect(coordinator).to_not be_valid
  end
end