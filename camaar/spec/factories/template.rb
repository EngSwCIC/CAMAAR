FactoryBot.define do
  factory :template do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    trait :template1 do
      id { 1 }
      name { 'A' }
      role {'discente'}
      coordinator_id { 100 }
    end
    trait :template2 do
      id { 2 }
      name { 'B' }
      role {'docente'}
      coordinator_id { 100 }
    end
  end
end
