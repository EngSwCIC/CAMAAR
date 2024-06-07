require "json"
require_relative "../config/environment"


departments = JSON.parse(File.read("./db/departments.json"))
classes = JSON.parse(File.read("./db/classes.json"))
classes_members = JSON.parse(File.read("./db/class_members.json"))

# parse departments
departments.each do |dpt|
  admin_email = "admin." + dpt["initials"].downcase + "@gmail.com"
  admin = Admin.create!({
    email: admin_email,
    password: "admin123",
    password_confirmation: "admin123",
    confirmed_at: Time.now.utc,
  })

  department = Department.create!(
    { id: dpt["id"],
      name: dpt["name"],
      initials: dpt["initials"] }
  )

  Coordinator.create!({
    name: "Jhon Doe",
    email: admin_email,
    department_id: department.id,
    admin_id: admin.id,
  })
end

#parse classes
classes.each do |subject_class|
  initials = subject_class["code"].gsub(/[^a-zA-Z]/, "")
  SubjectClass.create!(
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

# parse members (teacher and students)
classes_members.each do |data|
  teacher_user = User.create!({
    email: data["docente"]["email"],
    password: "professor123",
    password_confirmation: "professor123",
    confirmed_at: Time.now.utc,
  })

  teacher = Teacher.create!(
    {
      name: data["docente"]["nome"],
      formation: data["docente"]["formacao"],
      registration: data["docente"]["usuario"],
      occupation: data["docente"]["ocupacao"],
      email: data["docente"]["email"],
      department_id: Department.find_by(name: data["docente"]["departamento"]).id,
      user_id: teacher_user.id,
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
    student_user = User.create!({
      email: student_data["email"],
      password: "aluno123",
      password_confirmation: "aluno123",
      confirmed_at: Time.now.utc,
    })

    student = Student.create!({
      name: student_data["nome"],
      course: student_data["curso"],
      registration: student_data["matricula"],
      formation: student_data["formacao"],
      occupation: student_data["ocupacao"],
      email: student_data["email"],
      user_id: student_user.id,
    })

    Enrollment.create!({
      student_id: student.id,
      subject_class_id: subject_class.id,
    })
  end
end
