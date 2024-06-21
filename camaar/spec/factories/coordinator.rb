FactoryBot.define do
  factory :coordinator do
    trait :coordinator1 do
      id { 100 }
      name { 'Mandelli' }
      admin_id { 100 }
      department_id { 508 }
      email { 'mandelli@unb.br' }
    end
    trait :coordinator2 do
      id { 101 }
      name { 'Mandelli' }
      admin_id { 101 }
      department_id { 510 }
      email { 'test@unb.br' }
    end
  end
end
