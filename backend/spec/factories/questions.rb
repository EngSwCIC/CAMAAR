FactoryBot.define do
  factory :question do
    code { 1 }
    survey { nil }
    description { "MyString" }
  end
end
