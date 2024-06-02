require "json"
require_relative "../config/environment"

departments = JSON.parse(File.read("./db/departments.json"))
classes = JSON.parse(File.read("./db/classes.json"))
classes_members = JSON.parse(File.read("./db/class_members.json"))

departments.each do |dpt|
  Department.find_or_create_by(
    { id: dpt["id"],
      name: dpt["name"],
      initials: dpt["initials"] }
  )
end

classes.each do |subject_class|
  initials = subject_class["code"].gsub(/[^a-zA-Z]/, "")
  SubjectClass.find_or_create_by(
    {
      subject: subject_class["code"],
      name: subject_class["name"],
      code: subject_class["class"]["classCode"],
      semester: subject_class["class"]["semester"],
      schedule: subject_class["class"]["time"],
      department_id: Department.find_by(initials: initials).id,
    }
  )
end

classes_members.each do |data|
  teacher = Teacher.find_or_create_by(
    {
      name: data["docente"]["nome"],
      formation: data["docente"]["formacao"],
      registration: data["docente"]["usuario"],
      occupation: data["docente"]["ocupacao"],
      email: data["docente"]["email"],
      department_id: Department.find_by(name: data["docente"]["departamento"]).id,
    }
  )

  subject_class = SubjectClass.find_by(
    { subject: data["code"],
      code: data["classCode"],
      semester: data["semester"] }
  )

  subject_class.update({
    teacher_id: teacher.id,
  })

  data["discente"].each do |student_data|
    student = Student.find_or_create_by({
      name: student_data["nome"],
      course: student_data["curso"],
      registration: student_data["matricula"],
      formation: student_data["formacao"],
      occupation: student_data["ocupacao"],
      email: student_data["email"],
    })

    Enrollment.find_or_create_by({
      student_id: student.id,
      subject_classes_id: subject_class.id,
    })

  end
end
