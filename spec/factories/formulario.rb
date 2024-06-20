FactoryBot.define do
  factory :formulario do
    nome { Faker::Lorem.word }
    association :formulario_template
    perguntas { Faker::Lorem.paragraph }
  end
end