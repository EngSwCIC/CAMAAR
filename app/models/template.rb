# frozen_string_literal: true

# Model representing a form template.
#
class Template < ApplicationRecord
  belongs_to :semester
  has_many :questions

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << self.questions.map(&:label)
      csv << self.questions.map(&:input)
    end
  end
  
end
