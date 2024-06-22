FactoryGirl.define do
  factory :turmas_dicente do
    association :turma
    association :dicente
  end
end
