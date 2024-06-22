FactoryGirl.define do
  factory :resultado do
    association :dicente
    association :formulario

    transient do
      respostas_count { 3 }
    end

    after(:build) do |resultado, evaluator|
      resultado.respostas = build_list(:resposta, evaluator.respostas_count, resultado: resultado)
    end

    factory :resultado_completo do
      after(:build) do |resultado|
        formulario = resultado.formulario
        resultado.respostas = formulario.questaos.map do |questao|
          build(:resposta, questao: questao, resultado: resultado)
        end
      end
    end
  end
end
