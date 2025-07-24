class TemplateQuestion < ApplicationRecord
  belongs_to :template
  has_many :question_answers, dependent: :destroy

  validates :question_text, presence: true
  validates :question_type, presence: true,
            inclusion: { in: %w[text radio checkbox scale] }

  scope :ordered, -> { order(:position) }

  def options_array
    return [] if options.blank?
    JSON.parse(options) rescue []
  end

  def options_array=(value)
    self.options = value.to_json
  end
end
