class SigaaManagementController < ApplicationController
  def import_sigaa_data
    semester_id = Semester.next_semester_id
    import_professors
    import_class_members
    import_disciplines(semester_id)
  end

  def import_sigaa_data
    import_professors
    import_class_members
    import_disciplines(semester_id)
  end

  private

  def import_professors
    json_file_path = '/home/eduardomarciano/Documents/GitHub/QuickClassEvalFork/db/data/professors.json'
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |professor_data|
      Professor.create_by_json(professor_data)
    end
  end

  def import_disciplines(semester_id)
    json_file_path = '/home/eduardomarciano/Documents/GitHub/QuickClassEvalFork/db/data/discipline.json'
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |discipline_data|
      Discipline.create_by_json(discipline_data, semester_id)
    end
  end

  def import_class_members
    json_file_path = '/home/eduardomarciano/Documents/GitHub/QuickClassEvalFork/db/data/class_members.json'
    json_data = JSON.parse(File.read(json_file_path))

    json_data.each do |student_data|
      SignUpAvailable.create_by_json(student_data["email"])
    end
  end
end
