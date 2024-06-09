FactoryBot.define do
  factory :professor do
    id {1}
    email { "professor@example.com" }
    encrypted_password { "password" }
    nome { "Nome Professor" }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}
    isadmin { false }
  end
end
