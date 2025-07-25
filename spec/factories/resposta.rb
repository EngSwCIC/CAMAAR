# frozen_string_literal: true

FactoryBot.define do
  factory :respostum do
    association :formulario
    association :pergunta, factory: :perguntum
    resposta_texto { 'Texto da resposta' }
    uuid_anonimo { SecureRandom.uuid }
  end
end
