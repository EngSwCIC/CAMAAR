FactoryBot.define do
  factory :department do
    id { 508 }
    initials { 'CIC' }
    name { 'DEPTO CIÊNCIAS DA COMPUTAÇÃO' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
  end
end
