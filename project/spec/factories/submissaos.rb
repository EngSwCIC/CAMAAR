FactoryBot.define do
  factory :submissao do
    formulario
    association :user
  end
end
