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
    CSV.generate(headers: true)  do|csv|
      all.each do |semester|
        disciplines = Discipline.where(semester_id: semester.id) 

        csv << [semester.to_s]
        csv << ["Sem disciplinas."] if disciplines.empty?
        csv << [nil]

        disciplines.each do |discipline|

          csv << ["#{discipline.code} - #{discipline.name}"]
          csv << ["Sem formulários."] if discipline.forms.empty?
          csv << [nil]

          discipline.forms.each do |form|

            csv << ["Formulário #{form.id}"]
            csv << [nil]

            form.questions.each_with_index do |question, index|
              
              csv << ["#{index + 1}. #{question.label}"]
              csv << ["Sem respostas fornecidas."] if question.answers.empty?
              csv << [nil]

              question.answers.each do |answer|
                csv << [User.find(answer.user_id), answer.answer]
              end
              csv << [nil] if !question.answers.empty?

            end
          end
        end
      end
    end
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      disciplines = Discipline.where(semester_id: self.id)

      csv << ["Sem disciplinas."] if disciplines.empty?

      disciplines.each do |discipline|

        csv << ["#{discipline.code} - #{discipline.name}"]
        csv << ["Sem formulários."] if discipline.forms.empty?
        csv << [nil]

        discipline.forms.each do |form|

          csv << ["Formulário #{form.id}"]
          csv << [nil]

          form.questions.each_with_index do |question, index|

            csv << ["#{index + 1}. #{question.label}"]
            csv << ["Sem respostas fornecidas."] if question.answers.empty?
            csv << [nil]

            question.answers.each do |answer|
              csv << [User.find(answer.user_id), answer.answer]
            end
            csv << [nil] if !question.answers.empty?

          end
        end
      end
    end
  end

  def self.find_by_id(id)
    find(id)
  end

end
