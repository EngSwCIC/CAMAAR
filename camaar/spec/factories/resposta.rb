FactoryGirl.define do
  factory :resposta do
    association :resultado
    association :questao
    conteudo "Conteúdo da resposta"

    trait :invalida do
      conteudo nil
    end
  end
end
