FactoryBot.define do
  factory :template do
    association :admin, factory: %i[user admin]
    sequence(:title) { |n| "Template #{n}" }
    target_role { "discente" }

    trait :docente do
      target_role { "docente" }
    end

    trait :com_questao do
      after(:create) do |template|
        create(:questao, template: template)
      end
    end
  end
end
