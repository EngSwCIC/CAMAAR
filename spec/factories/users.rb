# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    name { Faker::Name.name }
    matricula { Faker::Number.number(digits: 8).to_s }
    role { :admin }

    trait :aluno do
      role { :aluno }
    end

    trait :professor do
      role { :professor }
    end

    trait :admin do
      role { :admin }
    end

    trait :coordenador do
      role { :coordenador }
    end
  end
end
