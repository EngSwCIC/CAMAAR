FactoryBot.define do
  factory :user do
    password { 'abc123' }
    password_confirmation { 'abc123' }
    confirmed_at { Time.now.utc }

    trait :user1 do
      email { 'test@gmail.com' }
    end

    trait :user2 do
      email { 'test2@gmail.com' }
    end

    trait :user3 do
      email { 'test3@gmail.com' }
    end

    trait :user4 do
      id { 8 }
      email { 'peluticaio@gmail.com' }
    end

    trait :user5 do
      id { 100 }
      email { 'chacon@unb.br' }
    end
  end
end
