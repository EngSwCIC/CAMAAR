FactoryGirl.define do
  factory :dicente do
    sequence(matricula) {|n| "#{n}"}
    curso "Matemática"
    association :user

    factory :dicente_with_turmas do
      transient do
        turmas_count { 3 }
      end

      after(:create) do |dicente, evaluator|
        create_list(:turma, evaluator.turmas_count, dicentes: [dicente])
      end
    end
  end
end
