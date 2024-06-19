class Template < ApplicationRecord
  has_many :form
  has_many :questions, as: :formlike

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      template.questions.each do |question|
        csv << [question.label, question.input]
      end

      csv << [nil]
    end
  end
end
