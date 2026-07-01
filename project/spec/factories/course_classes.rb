FactoryBot.define do
  factory :course_class do
    association :department
    sequence(:code) { |n| "CIC#{n.to_s.rjust(4, '0')}" }
    sequence(:class_code) { |n| "T#{n}" }
    name { "Disciplina Teste" }
    semester { "2026.1" }
    time { "10:00" }
  end
end
