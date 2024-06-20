FactoryBot.define do
  factory :form do
    open { true }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :form1 do
      id { 1 }
      name { 'Avaliação Institucional' }
      role { 'discente' }
      open { true }
      coordinator_id { 100 }
      subject_class_id { 1 }
    end

    trait :form2 do
      id { 2 }
      name { 'Avaliação de Turmas' }
      role { 'docente' }
      open { true }
      coordinator_id { 100 }
      subject_class_id { 1 }
    end

    trait :form3 do
      id { 3 }
      name { 'Avaliação' }
      role { 'discente' }
      open { true }
      coordinator_id { 100 }
      subject_class_id { 1 }
    end

    trait :form4 do
      id { 4 }
      name { 'sad-path' }
      role { 'discente' }
      open { true }
      coordinator_id { 100 }
      subject_class_id { 2 }
    end
  end
end
