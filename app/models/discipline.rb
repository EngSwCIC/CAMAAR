class Discipline < ApplicationRecord
  has_many :form_disciplines
  has_many :forms, through: :form_disciplines

  def self.create_by_json(data, semester_id)
    existing_discipline = find_by(code: data['code'], semester_id: semester_id)
    unless existing_discipline
      create!(
        name: data['name'],
        code: data['code'],
        professor_registration: data['professor_registration'],
        semester_id: semester_id
      )
    end
  end

  def self.all_disciplines_info
    disciplines_info = []
    all.each do |discipline|
      professor = Professor.find_by_registration(discipline.professor_registration)
      semester = Semester.find_by_id(discipline.semester_id)
  
      info = discipline.professor_and_semester_info(discipline, professor, semester)
      disciplines_info << info.merge(discipline_name: discipline.name)
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
end
