# frozen_string_literal: true

class Curso < ApplicationRecord
  validates :nome, presence: true, length: { minimum: 2 }
end
