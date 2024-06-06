FactoryBot.define do
    factory :professor do
      email { Faker::Internet.email }
      encrypted_password { Faker::Internet.password }
      reset_password_token { nil }
      reset_password_sent_at { nil }
      remember_created_at { nil }
      nome { Faker::Name.name }
      departamento_id { FactoryBot.create(:departamento).id }
    end
  end
  