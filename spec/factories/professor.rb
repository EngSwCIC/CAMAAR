FactoryBot.define do
  factory :professor do
    sequence(:nome) { |n| "Professor #{n}" }
    email { Faker::Internet.email }
    encrypted_password { 'password123' }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    isadmin { false }


  end
end
