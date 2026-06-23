FactoryBot.define do
  factory :department do
    sequence(:code) { |n| "DEPT#{n}" }
    sequence(:name) { |n| "Departamento #{n}" }
  end
end
