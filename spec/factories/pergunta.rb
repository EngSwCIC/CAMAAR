# frozen_string_literal: true

FactoryBot.define do
  factory :perguntum do
    template { nil }
    titulo { 'MyString' }
    tipo { 1 }
    ordem { 1 }
  end
end
