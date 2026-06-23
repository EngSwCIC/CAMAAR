FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "Usuario #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:registration) { |n| "U#{1000 + n}" }
    role { :participant }
    password { "Senha@123" }

    trait :admin do
      role { :admin }
    end
  end
end
