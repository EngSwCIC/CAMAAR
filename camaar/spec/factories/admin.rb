FactoryBot.define do
  factory :admin do
    password { 'abc123' }
    password_confirmation { 'abc123' }
    confirmed_at { Time.now.utc }

    trait :adminroot do
      id { 1000 }
      email { 'root@gmail.com' }
    end
    trait :admin1 do
      id { 100 }
      email { 'mandelli@unb.br' }
    end
    trait :admin2 do
      id { 101 }
      email { 'admin.unb@unb.br' }
    end
  end
end
