FactoryBot.define do
  factory :formulario do
    association :admin, factory: %i[user admin]
    template
    association :course_class
    sequence(:title) { |n| "Formulário de Teste #{n}" }
    target_role { "discente" }

    trait :com_questao do
      after(:create) do |formulario|
        create(:questao, :de_formulario, formulario: formulario)
      end
    end
  end
end
