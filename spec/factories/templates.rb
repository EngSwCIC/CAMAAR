# frozen_string_literal: true

FactoryBot.define do
  factory :template do
    titulo { 'MyString' }
    publico_alvo { 1 }
    association :criado_por, factory: :user, role: 'admin'
    disciplina { nil }
  end
end
