FactoryBot.define do
  factory :template do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    trait :template1 do
      id { 1 }
      name { 'A' }
      coordinator_id { 100 }
    end
  end
end
