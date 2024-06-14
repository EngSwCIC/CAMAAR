# frozen_string_literal: true

# Model representing a form template.
#
class Template < ApplicationRecord
  belongs_to :semester
  has_many :questions
end
