class Template < ApplicationRecord
  belongs_to :semester
  has_many :form
  has_many :questions, as: :formlike

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      Semester.find_each do |semester|
        csv << [semester.to_s]
        csv << [nil]

        semester.templates.each do |template|
          csv << ["Template ##{template.id}"]
          csv << [nil]

          template.questions.each do |question|
            csv << [question.label, question.input]
          end

          csv << [nil]
        end
      end
    end
  end
end
