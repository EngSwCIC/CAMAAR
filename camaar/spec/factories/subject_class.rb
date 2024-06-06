FactoryBot.define do
  factory :subject_classes do
    sequence(:name) { |n| "Subject Class #{n}" }
  end
end
