# frozen_string_literal: true

FactoryBot.define do
  factory :turma do
    disciplina { nil }
    professor { nil }
    semestre { 'MyString' }
  end
end
