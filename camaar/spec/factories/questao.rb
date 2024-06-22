FactoryGirl.define do
  factory :questao do
    association :template
    pergunta { "Pergunta da questão" }

    after(:build) do |questao|
      questao.tipo ||= build(:tipo)
    end

    transient do
      alternativas_count { 4 }
    end

    after(:build) do |questao, evaluator|
      questao.alternativas = build_list(:alternativa, evaluator.alternativas_count, questao: questao)
    end

    trait :invalida do
      pergunta { nil }
    end
  end
end
