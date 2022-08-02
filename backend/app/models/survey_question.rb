##
# Essa classe representa o model ActiveRecord que armazena pergunta do Survey 
# que será utilizada para avaliar cada Cclass

class SurveyQuestion < ApplicationRecord
  belongs_to :survey
  belongs_to :question_type
  has_many :question_answers
  has_many :question_options
  has_many :likert_scale_questions
  accepts_nested_attributes_for :question_options
  accepts_nested_attributes_for :question_type
  accepts_nested_attributes_for :likert_scale_questions

  def as_json(options: {})
    super(
      only: [:question, :question_number, :optional, :question_type_id],
      include:[
        :question_type => {
          only: [:name]
        },
        :question_options => {
          only: [:option, :content]
        },
        :likert_scale_questions => {
          only: [:question_number, :question, :scale_points]
        }
      ]
    )
  end
end
