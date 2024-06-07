FactoryBot.define do
    factory :reports_professor do
      formularios_id { FactoryBot.create(:formulario).id }
    end
  end
  