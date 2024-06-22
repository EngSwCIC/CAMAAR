FactoryGirl.define do
  factory :tipo do
    nome "Tipo de Questão"
    numeroDeAlternativas 3
    discursiva true

    trait :discursiva_false do
      discursiva false
    end

    trait :numero_de_alternativas_0 do
      numeroDeAlternativas  0
    end

    trait :numero_de_alternativas_5 do
      numeroDeAlternativas 5
    end

  end
end
