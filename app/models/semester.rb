class Semester < ApplicationRecord
  validates :half, uniqueness: { scope: :year }
  has_many :forms
  has_many :templates

  def to_s
    "#{half ? '2' : '1'}-#{year}"
  end

  def self.next_semester_id
    latest_semester = order(id: :desc).first

    if latest_semester.nil?
      half = 0
      year = 2020
    elsif latest_semester.half
      half = 0
      year = latest_semester.year + 1
    else
      half = 1
      year = latest_semester.year
    end
    new_semester = create(half:, year:)
    new_semester.id
  end

  def self.current_semester
    latest_semester = order(id: :desc).first
    if latest_semester
      half = if latest_semester.half
               2
             else
               1
             end
      "#{latest_semester.year}.#{half}."
    else
      'Sem semestre cadastrado.'
    end
  end

  def self.current_semester_id
    latest_semester = order(id: :desc).first
    return latest_semester.id if latest_semester

    latest_semester
  end

  def self.to_csv
    CSV.generate(headers: true, col_sep: ";")  do|csv|
      all.each do |semester|
        disciplines = Discipline.where(semester_id: semester.id)
        disciplines_empty = disciplines.empty? ? ["Sem disciplinas."] : []

        csv << [semester.to_s] + disciplines_empty

        disciplines.each do |discipline|
          forms_empty = discipline.forms.empty? ? ['Sem formulários.'] : []
          csv << ["#{discipline.code} - #{discipline.name}"] + forms_empty

          discipline.forms.each do |form|

            csv << ["Formulário #{form.id}"]

            form.questions.each_with_index do |question, index|
              answers_empty = question.answers.empty? ? ['Sem respostas fornecidas.'] : []
              answers = question.answers.pluck(:answer)
              csv << ["#{index + 1}. #{question.label}"] + answers_empty + answers
            end
          end
        end
      end
    end
  end

  def to_csv
    CSV.generate(headers: true, col_sep: ";") do |csv|
      disciplines = Discipline.where(semester_id: self.id)
      disciplines_empty = disciplines.empty? ? ["Sem disciplinas."] : []

      csv << [self.to_s] + disciplines_empty

      disciplines.each do |discipline|
        forms_empty = discipline.forms.empty? ? ['Sem formulários.'] : []
        csv << ["#{discipline.code} - #{discipline.name}"] + forms_empty

        discipline.forms.each do |form|

          csv << ["Formulário #{form.id}"]

          form.questions.each_with_index do |question, index|
            answers_empty = question.answers.empty? ? ['Sem respostas fornecidas.'] : []
            answers = question.answers.pluck(:answer)
            csv << ["#{index + 1}. #{question.label}"] + answers_empty + answers
          end
        end
      end
    end
  end

  def self.find_by_id(id)
    find(id)
  end

end
