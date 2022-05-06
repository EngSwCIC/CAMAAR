class Survey < ApplicationRecord
  has_many :survey_answers
  has_many :survey_questions, dependent: :destroy
  accepts_nested_attributes_for :survey_questions

  validates :name, :description, :expiration_date, :semester, presence: true

  def is_expired?
    self.expiration_date <= DateTime.now
  end

  def as_json(options: {})
    super(include: [
          :survey_questions => {
            include: [
              multiple_choice: {include: :options},
              likert_scale: {include: :likert_questions}
            ]
          }
        ])
  end
end
