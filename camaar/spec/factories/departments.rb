FactoryBot.define do
  factory :departments do
    initials {"CIC"}
    name {"c"}
    schedule {"d"}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
  end
end
