class Form < ApplicationRecord
  belongs_to :template, optional: true
  has_many :questions, as: :formlike
  belongs_to :semester, optional: true

  validate :semester_required
  before_create :import_template_data

  private

  def semester_required
    return unless template.nil? && semester.nil?

    errors.add(:semester, "can't be nil when template is also nil")
  end

  def import_template_data
    return if template.nil?

    self.semester = template.semester
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
