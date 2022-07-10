class SurveyAnswer < ApplicationRecord
  belongs_to :survey
  belongs_to :member
  belongs_to :cclass
  has_many :question_answers
  accepts_nested_attributes_for :question_answers

  def as_json(options: {})
    super(
      only: [
        :survey_id,
        :cclass_id,
        :member_id
      ],
      include: [
        :question_answers => {
          only: [:survey_question_id, :answer],
          include: [
            :likert_scale_answer => {
              only: [:likert_scale_question_id, :answer]
            }
          ]
        }
      ]
    )
  end

end
