FactoryBot.define do
  factory :aluno do
    sequence(:nome) { |n| "Aluno #{n}" }
    email { Faker::Internet.email }
    encrypted_password { 'password123' }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    matricula { Faker::Number.number(digits: 9) }
    curso { Faker::Educator.course }
    association :materia
  end
end
