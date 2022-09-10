FactoryBot.define do
  factory :subject do
    code { "Code" + rand(10000).to_s }
    name { "Name" + rand(10000).to_s }
  end
end