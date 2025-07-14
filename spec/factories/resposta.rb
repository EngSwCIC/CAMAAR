# frozen_string_literal: true

FactoryBot.define do
  factory :respostum do
    formulario { nil }
    pergunta { nil }
    opcao { nil }
    resposta_texto { 'MyText' }
    turma { nil }
    uuid_anonimo { 'MyString' }
  end
end
