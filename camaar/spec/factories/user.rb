FactoryGirl.define do
  factory :user do
    nome "Alberto"
    email "email.real@gmail.com"
    password "senha"
    usuario "Dicente"
    formacao "pos-graduado"

    trait :docente do
      role { :docente }
      after(:create) do |user|
        create(:docente, user: user)
      end
    end

    trait :dicente do
      role { :dicente }
      after(:create) do |user|
        create(:dicente, user: user)
      end
    end

  end
end
