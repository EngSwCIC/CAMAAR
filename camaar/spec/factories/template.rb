FactoryBot.define do
  factory :template do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    draft { false }

    trait :template1 do
      id { 1 }
      name { 'Template1' }
      role { 'discente' }
      coordinator_id { 100 }
    end
    trait :template2 do
      id { 2 }
      name { 'Template2' }
      role { 'docente' }
      coordinator_id { 100 }
    end
  end
end
