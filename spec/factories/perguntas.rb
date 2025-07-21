FactoryBot.define do
  factory :pergunta do
    pergunta { "Qual a sua opinião?" }
    tipo { 1 } # Default: texto

    trait :radio do
      tipo { 0 }
      transient do
        opcoes_count { 2 } # Número de opções padrão
      end

      after(:create) do |pergunta, evaluator|
        evaluator.opcoes_count.times do |i|
          create(:opcao, pergunta: pergunta, opcao: "Opção #{i + 1}")
        end
      end
    end
  end
end