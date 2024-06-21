FactoryBot.define do
  factory :user do
    sequence(:email) { |n|  "teste#{n}@email.com" }
    sequence(:matricula) { |n| "#{n}" }
    password { "123456" }
  end
end
