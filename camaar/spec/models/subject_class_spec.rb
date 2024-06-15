require 'rails_helper'

RSpec.describe SubjectClass, type: :model do
  it 'é válido com atributos válidos e FKS existentes' do
    department = create(:department, :departament1)

    admin = create(:admin, :admin1)

    user1 = create(:user, :user1)
    user2 = create(:user, :user2)
    user3 = create(:user, :user3)
    user4 = create(:user, :user4)
    user5 = create(:user, :user5)

    student1 = create(:student, :student1)
    student2 = create(:student, :student2)
    student3 = create(:student, :student3)
    student4 = create(:student, :student4)

    coordinator = create(:coordinator, :coordinator1)
    template = create(:template)
    template_questions = create(:template_question)

    teacher = create(:teacher)

    subject_class1 = create(:subject_class)

    expect(subject_class1).to be_valid
  end

  it 'é inválido sem FKS existentes' do
    subject_class = build(:subject_class)
    expect(subject_class).to_not be_valid
  end
end
