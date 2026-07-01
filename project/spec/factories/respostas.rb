FactoryBot.define do
  factory :respostum do
    submissao
    questao
    valor_texto { "Resposta de teste" }
    valor_numerico { nil }

    trait :numerica do
      valor_texto { nil }
      valor_numerico { 5 }
    end
  end
end
