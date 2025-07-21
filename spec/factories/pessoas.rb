FactoryBot.define do
  factory :pessoa do
    sequence(:email) { |n| "user#{n}@example.com" }
    nome { "Usuário Teste" }
    matricula { "123456" }
    password { "password" }
    password_confirmation { "password" }

    trait :aluno do
      after(:create) do |pessoa|
        create(:cargo, email: pessoa.email, funcao: 1)
      end
    end

    trait :professor do
      after(:create) do |pessoa|
        create(:cargo, email: pessoa.email, funcao: 2)
      end
    end

    trait :admin do
      after(:create) do |pessoa|
        create(:cargo, email: pessoa.email, funcao: 0)
      end
    end

    trait :admin_professor do
      after(:create) do |pessoa|
        create(:cargo, email: pessoa.email, funcao: 0)
        create(:cargo, email: pessoa.email, funcao: 2)
      end
    end
  end

  factory :cargo do
    email { "user@example.com" }
    funcao { 1 } # 0 = admin
  end
end