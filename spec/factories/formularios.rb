# frozen_string_literal: true

FactoryBot.define do
  factory :formulario do
    association :template
    association :turma
    association :coordenador, factory: :user
    data_envio { 1.day.from_now }
    data_fim { 7.days.from_now }
    ativo { true }
    disciplina { nil }
  end
end
