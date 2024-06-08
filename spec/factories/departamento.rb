# spec/factories/departamentos.rb
FactoryBot.define do
  factory :departamento do
    sequence(:nome) { |n| "Departamento#{n}" }
  end
end

