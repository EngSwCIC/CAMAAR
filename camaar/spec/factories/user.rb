FactoryGirl.define do
  factory :user do
    nome "Alberto"
    email "email.real@gmail.com"
    password "senha123"
    usuario "Dicente"
    formacao "pos-graduado"

    trait :docente do
      role { :docente }
      after(:create) do |user|
        FactoryGirl.create(:docente, user: user)
      end
    end

    trait :dicente do
      role { :dicente }
      after(:create) do |user|
        FactoryGirl.create(:dicente, user: user)
      end
    end

  end
end
