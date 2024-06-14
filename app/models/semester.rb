# frozen_string_literal: true

# Represents a semester, half and year together must not repeat
#
class Semester < ApplicationRecord
  has_many :templates
  validates :half, uniqueness: { scope: :year }
end
