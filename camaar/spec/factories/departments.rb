FactoryBot.define do
  factory :department do
    id { 508 }
    initials { 'A' }
    name { 'c' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
  end
end
