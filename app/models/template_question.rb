class TemplateQuestion < ApplicationRecord
  belongs_to :template

  validates :question_type, inclusion: { in: %w(radio checkbox text) }
end
