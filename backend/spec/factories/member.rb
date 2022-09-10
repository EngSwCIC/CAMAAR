FactoryBot.define do
    factory :member do
        name { 'John Doe' }
        registration { rand(10000).to_s }
        username { 'jhondoe' }
        degree { 'Degree' }
        course { 'Course' }
    end
end