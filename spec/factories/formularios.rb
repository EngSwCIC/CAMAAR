FactoryBot.define do
  factory :formulario do
    nome { "Formulário #{SecureRandom.hex(2)}" }
    association :turma
    association :ligacao_pergunta

    trait :com_perguntas do
      after(:create) do |formulario|
        create(:pergunta, ligacao_pergunta: formulario.ligacao_pergunta)
        create(:pergunta, :radio, ligacao_pergunta: formulario.ligacao_pergunta)
      end
    end

    trait :invalido do
      nome { "" }
    end

    trait :com_respostas do
      after(:create) do |formulario|
        pergunta = create(:pergunta, ligacao_pergunta: formulario.ligacao_pergunta)
        create(:resposta, formulario: formulario, pergunta: pergunta, conteudo: "Resposta teste")
      end
    end

    trait :sem_respostas do
    end
  end
end