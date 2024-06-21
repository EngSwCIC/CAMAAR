FactoryBot.define do
  factory :enrollment do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :enrollment1 do
      id { 1 }
      student_id { 1 }
      subject_class_id { 1 }
    end

    trait :enrollment2 do
      id { 2 }
      student_id { 2 }
      subject_class_id { 1 }
    end

    trait :enrollment3 do
      id { 3 }
      student_id { 3 }
      subject_class_id { 1 }
    end

    trait :enrollment4 do
      id { 4 }
      student_id { 8 }
      subject_class_id { 1 }
    end

    trait :enrollment5 do
      id { 5 }
      student_id { 8 }
      subject_class_id { 2 }
    end
  end
end
