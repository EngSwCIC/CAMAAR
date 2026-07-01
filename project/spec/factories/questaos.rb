FactoryBot.define do
  factory :questao do
    template
    sequence(:enunciado) { |n| "Pergunta de teste #{n}?" }
    tipo { "text" }

    trait :rating do
      tipo { "rating" }
    end

    trait :de_formulario do
      template { nil }
      formulario
    end
  end
end
