# frozen_string_literal: true

FactoryBot.define do
  factory :perguntum do
    association :template
    texto { 'Pergunta de exemplo' }
    tipo { :subjetiva }
  end
end
