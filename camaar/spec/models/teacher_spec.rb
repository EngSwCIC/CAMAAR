require 'rails_helper'

RSpec.describe Teacher, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    department = create(:department, :departament1)
    admin = create(:admin, :admin1)
    user1 = create(:user, :user1)
    user2 = create(:user, :user2)
    user3 = create(:user, :user3)
    user4 = create(:user, :user4)
    user5 = create(:user, :user5)
    coordinator = create(:coordinator, :coordinator1)
    teacher = create(:teacher)
    expect(teacher).to be_valid
  end

  it 'é inválido sem FKS existentes' do
    teacher = build(:teacher)
    expect(teacher).to_not be_valid
  end
end
