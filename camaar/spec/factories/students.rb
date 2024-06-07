FactoryBot.define do
  factory :student do
    sequence(:name) { |n| "test#{n}" }
    course { "CIC" }
    sequence(:registration) { |n| n }
    formation { "Graduando" }
    occupation { "Ocupado" }
    sequence(:email) { |n| "test#{n}@gmail.com" }
    sequence(:user_id) { |n| n }

    trait :student1 do
      name { "test1" }
      registration { 1 }
      email { "test1@gmail.com" }
      user_id { 1 }
    end

    trait :student2 do
      name { "test2" }
      registration { 2 }
      email { "test2@gmail.com" }
      user_id { 2 }
    end

    trait :student3 do
      name { "test3" }
      registration { 3 }
      email { "test3@gmail.com" }
      user_id { 3 }
    end

    trait :student4 do
      name { "test4" }
      registration { 4 }
      email { "test4@gmail.com" }
      user_id { 4 }
    end
  end
end
