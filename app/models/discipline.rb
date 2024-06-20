class Discipline < ApplicationRecord
  has_many :form_disciplines
  has_many :forms, through: :form_disciplines

  def self.create_by_json(data, semester_id)
    create!(
      name: data['name'],
      code: data['code'],
      professor_registration: data['professor_registration'],
      semester_id:
    )
  end

  def self.all_disciplines_info
    disciplines_info = []
    all.each do |discipline|
      professor = Professor.find_by_registration(discipline.professor_registration)
      semester = Semester.find_by_id(discipline.semester_id)
  
      info = discipline.professor_and_semester_info(discipline, professor, semester)
      disciplines_info << info.merge(discipline_name: discipline.name, id: discipline.id)
    end
    disciplines_info
  end

  def professor_and_semester_info(discipline, professor, semester)
    professor_name = professor&.name
    professor_department_code = professor&.department_code
    semester_name = if semester
                      half = semester.half ? 2 : 1
                      "#{semester.year}.#{half}."
                    else
                      'Sem semestre cadastrado.'
                    end
    {
      discipline_name: discipline.name,
      professor_name: professor_name,
      professor_department_code: professor_department_code,
      semester_name: semester_name
    }
  end
  
  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << [self.name]
      csv << [nil] if !self.forms.empty?

      self.forms.each do |form|
        csv << ["Formulário #{form.id}"]
        csv << [nil] if !form.questions.empty?

        form.questions.each do |question|
          csv << [question.label]
          csv << [nil] if !question.answers.empty?

          question.answers.each do |answer|
            csv << [User.find(answer.user_id), answer.answer]
          end
          csv << [nil]
        end
      end
    end
  end
end
