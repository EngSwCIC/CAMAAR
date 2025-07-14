# frozen_string_literal: true

FactoryBot.define do
  factory :formulario do
    association :template
    association :turma
    association :coordenador, factory: :user
    data_envio { '2025-07-11 12:49:31' }
    data_fim { '2025-07-11 12:49:31' }
  end
end
