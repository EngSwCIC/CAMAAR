FactoryBot.define do
    factory :formulario do
      nome { Faker::Lorem.word }
      perguntas { Faker::Lorem.paragraph }
      association :formulario_template
    end
  end
  