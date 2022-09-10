FactoryBot.define do
    factory :likert_scale_question do
        question { "Question" }
        scale_points { rand(5) }
    end
end