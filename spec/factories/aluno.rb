FactoryBot.define do
  factory :aluno do
    sequence(:nome) { |n| "Aluno #{n}" }
    email { Faker::Internet.email }
    encrypted_password { 'password123' }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    sequence(:matricula) { |n| "2023#{n}" }  
    curso { "Curso de Exemplo" }

  end
end
