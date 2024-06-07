FactoryBot.define do
    factory :reports_aluno do
      formularios_id { FactoryBot.create(:formulario).id }
    end
  end
  