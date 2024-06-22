FactoryGirl.define do
  factory :alternativa do
    association :questao
    texto "Texto da alternativa"

    trait :invalida do
      texto nil
    end
  end
end
