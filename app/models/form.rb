class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :discipline

  before_create :import_template_data

  private

  def import_template_data
    return if template.nil?

    template.questions.each do |question|
      question_params = {
        formlike: self,
        label: question.label,
        description: question.description,
        format: question.format
      }
      questions << case question.type
                   when 'MultipleChoiceQuestion'
                     MultipleChoiceQuestion.new(question_params)
                   when 'TextInputQuestion'
                     TextInputQuestion.new(question_params)
                   else # Usually a 'Question' class
                     Question.new(question_params)
                   end
    end
  end
end
