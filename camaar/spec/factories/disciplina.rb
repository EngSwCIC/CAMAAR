FactoryGirl.define do
  factory :disciplina do
    codigo { "DISC101" }
    nome { "Disciplina de Exemplo" }

    factory :disciplina_with_turmas do
      transient do
        turmas_count { 3 }
      end

      after(:create) do |disciplina, evaluator|
        create_list(:turma, evaluator.turmas_count, disciplina: disciplina)
      end
    end
  end
end
