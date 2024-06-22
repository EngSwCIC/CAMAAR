FactoryBot.define do
  factory :subject_class do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :subject_class1 do
      id { 1 }
      semester { '2021.2' }
      subject { 'CIC0097' }
      code { 'TA' }
      name { 'ENGENHARIA DE SOFTWARE' }
      schedule { '35T45' }
      department_id { 508 }
      teacher_id { 100 }
    end

    trait :subject_class2 do
      id { 2 }
      semester { '2021.2' }
      subject { 'CIC0105' }
      code { 'TA' }
      name { 'BANCOS DE DADOS' }
      schedule { '35M12' }
      department_id { 508 }
      teacher_id { 6 }
    end

    trait :subject_class3 do
      id { 3 }
      semester { '2021.2' }
      subject { 'CIC0202' }
      code { 'TA' }
      name { 'PROGRAMAÇÃO CONCORRENTE' }
      schedule { '35M34' }
      department_id { 508 }
    end
  end
end
