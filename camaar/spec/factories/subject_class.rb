FactoryBot.define do
  factory :subject_class do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :subject_class1 do
      id { 1 }
      semester { '2021.2' }
      subject { 'CIC0097' }
      code { 'TA' }
      name { 'BANCOS DE DADOS' }
      schedule { '24M34' }
      department_id { 508 }
      teacher_id { 100 }
    end
  end
end
