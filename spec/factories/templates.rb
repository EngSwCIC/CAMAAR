FactoryBot.define do
  factory :template do
    sequence(:name) { |n| "Template #{n}" }
  end
end
