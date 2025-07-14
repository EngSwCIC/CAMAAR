# frozen_string_literal: true

# Model representing a course (curso)
class Curso < ApplicationRecord
  validates :nome, presence: true, length: { minimum: 2 }

  has_many :disciplinas, dependent: :destroy
end
