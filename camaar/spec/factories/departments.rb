FactoryBot.define do
  factory :department do
    id {1}
    initials {"A"}
    name {"c"}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
  end
end
