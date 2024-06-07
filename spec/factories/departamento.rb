FactoryBot.define do
  factory :departamento do
    nome { Faker::Company.unique.industry }
  end
end
