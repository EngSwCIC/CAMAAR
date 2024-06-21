FactoryBot.define do
  factory :department do
    created_at { Time.now.utc }
    updated_at { Time.now.utc }

    trait :root do
      id { 1 }
      initials { 'ROOT' }
      name { 'ROOT' }
    end

    trait :departament1 do
      id { 508 }
      initials { 'CIC' }
      name { 'DEPTO CIÊNCIAS DA COMPUTAÇÃO' }
    end
  end
end
