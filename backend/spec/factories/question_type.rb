FactoryBot.define do
  factory :question_type do
      name { ['multiple_choice', 'discursive', 'likert_scale'].sample }
  end
end