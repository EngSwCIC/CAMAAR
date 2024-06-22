FactoryBot.define do
  factory :professor do
    password {'teste123456'}
    association :departamento
    nome { Faker::Name.name }
    email { Faker::Internet.email }
    isadmin { Faker::Boolean.boolean }
  end
end