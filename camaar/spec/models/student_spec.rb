require 'rails_helper'

RSpec.describe Student, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do

    user1 = create(:user, :user1)
    user2 = create(:user,:user2)
    user3 = create(:user, :user3)
    user4 = create(:user,:user4)

    student1 = create(:student, :student1)
    student2 = create(:student, :student2)
    student3 = create(:student, :student3)
    student4 = create(:student, :student4)


    expect(student1).to be_valid
    expect(student2).to be_valid
    expect(student3).to be_valid
    expect(student4).to be_valid

  end

  it 'é inválido com atributos duplicados no banco de dados' do
    user1 = create(:user, :user1)
    student1 = create(:student,:student1)
    student2 = build(:student,email:student1.email)
    expect(student2).to_not be_valid
  end
end
