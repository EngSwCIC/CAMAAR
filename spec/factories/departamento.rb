FactoryBot.define do
  factory :departamento do
    id {1}
    nome { "CIC" }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
  end
end
