FactoryBot.define do
  factory :user do
    email { "teste@email.com" }
    matricula { "123456789" }
    password { "123456" }
  end
end
