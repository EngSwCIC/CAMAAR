# Assuming you have FactoryBot configured

FactoryBot.define do
  factory :study_class do
    sequence(:code) { |n| "CS#{n}" }
    name { "Sample" }
    sequence(:classCode) { |n| "CS101-#{n}" }
    semester { "Spring 2024" }
    time { "10:00 AM - 12:00 PM" }

    # Association with docente (teacher)
    association :docente, factory: :user
  end
end
