# frozen_string_literal: true

FactoryBot.define do
  factory :submissao_concluida do
    association :user
    association :formulario
    uuid_anonimo { SecureRandom.uuid }
  end
end
