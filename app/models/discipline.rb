class Discipline < ApplicationRecord
  has_many :forms

  def name_detailed
    "#{self[:code]} - #{self[:name]} #{Semester.find(self[:semester_id])}"
  end

  def self.create_by_json(data, semester_id)
    existing_discipline = find_by(code: data['code'], semester_id:)
    return if existing_discipline

    create!(
      name: data['name'],
      code: data['code'],
      professor_registration: data['professor_registration'],
      semester_id:
    )
  end

  def self.all_disciplines_info(email, admin_user)
    disciplines_info = []

    if admin_user
      disciplines = Discipline.all
    else
      discipline_codes = StudentDiscipline.where(student_email: email).pluck(:discipline_code)
      disciplines = Discipline.where(code: discipline_codes)
    end

    disciplines.each do |discipline|
      professor = Professor.find_by_registration(discipline.professor_registration)
      semester = Semester.find_by_id(discipline.semester_id)

      info = discipline.professor_and_semester_info(discipline, professor, semester)
      disciplines_info << info.merge(discipline_name: discipline.name, id: discipline.id)
    end
    disciplines_info
  end

  def self.all_disciplines_with_eval_info(email, admin_user)
    disciplines_info = []

    if admin_user
      disciplines = Discipline.all
    else
      discipline_codes = StudentDiscipline.where(student_email: email).pluck(:discipline_code)
      disciplines = Discipline.where(code: discipline_codes)
    end

    disciplines.where(id: Form.distinct.pluck(:discipline_id)).each do |discipline|
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
    form = Form.where(discipline:).first
    {
      discipline_name: discipline.name,
      professor_name:,
      professor_department_code:,
      semester_name:,
      form_id: form.nil? ? '' : form.id
    }
  end

  def to_csv
    CSV.generate(headers: true, col_sep: ";") do |csv|
      forms_empty = forms.empty? ? ['Sem formulários.'] : []
      csv << ["#{code} - #{name}"] + forms_empty

      forms.each do |form|
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
