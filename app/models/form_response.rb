require 'csv'

class FormResponse < ApplicationRecord
  belongs_to :study_class
  belongs_to :template

  def self.find_with_study_class(study_class)
    self.where(study_class: study_class)
  end

  def self.to_csv(forms)
    attributes = %w{form_id, turma semestre pergunta resposta data}
    CSV.generate(headers: true) do |csv|
      csv << attributes

      forms.each do |form|
        answers = JSON.parse form.response
        form.template.template_questions.each_with_index do |q, idx|
          csv << [form.id, form.study_class.classCode, form.study_class.semester, q.title, answers[idx], form.created_at]
        end
      end
    end
  end
end
