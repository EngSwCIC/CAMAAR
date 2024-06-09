FactoryBot.define do
  factory :teacher do
    id {1}
    registration {1}
    name {"chacon"}
    formation { "Graduado" }
    occupation { "Ocupado" }
    email {"chacon@unb.br"}
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    department_id {1}
    user_id {5}
  end
end
