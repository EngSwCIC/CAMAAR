require 'csv'

class FormResponse < ApplicationRecord
  belongs_to :study_class
  belongs_to :template

  def to_csv
    attributes = %w{turma semestre pergunta resposta data}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      answers = JSON.parse response
      template.template_questions.each_with_index do |q, idx|
        csv << [study_class.classCode, study_class.semester, q.title, answers[idx], created_at]
      end
    end
  end
end
