FactoryBot.define do
  factory :student do
    course { 'CIC' }
    formation { 'graduando' }
    occupation { 'discente' }

    trait :student1 do
      id {1}
      name { 'test1' }
      registration { 1 }
      email { 'test1@gmail.com' }
      user_id { 1 }
    end

    trait :student2 do
      id {2}
      name { 'test2' }
      registration { 2 }
      email { 'test2@gmail.com' }
      user_id { 2 }
    end

    trait :student3 do
      id {3}
      name { 'test3' }
      registration { 3 }
      email { 'test3@gmail.com' }
      user_id { 3 }
    end

    trait :student4 do
      id {8}
      name { 'Caio Otávio Peluti Alencar' }
      registration { 190_085_312 }
      email { 'peluticaio@gmail.com' }
      user_id { 8 }
    end
  end
end
