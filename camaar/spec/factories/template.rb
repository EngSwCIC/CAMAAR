FactoryBot.define do
  factory :template do
    id {1}
    name {"A"}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    coordinator_id {1}
  end
end
