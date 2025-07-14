# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


Answer.delete_all
Option.delete_all
Question.delete_all
AnsweredForm.delete_all
ClassForm.delete_all
Form.delete_all
Template.delete_all
ClassStudent.delete_all
ClassProfessor.delete_all
ClassGroup.delete_all
Subject.delete_all
User.delete_all

puts "Seeding started..."

users = []
5.times do |i|
  users << User.create!(
    name: "User #{i+1}",
    registration: "U#{1000+i}",
    email: "user#{i+1}@example.com",
    role: i < 3 ? "professor" : "student",
    password: "password#{i+1}"
  )
end

professors = users.select { |u| u.role == "professor" }
students = users.select { |u| u.role == "student" }

subjects = []
5.times do |i|
  subjects << Subject.create!(
    name: "Subject #{i+1}",
    code: "SUB#{i+1}00"
  )
end

class_groups = []
subjects.each_with_index do |subj, i|
  2.times do |j|
    class_groups << ClassGroup.create!(
      subject: subj,
      number: j+1,
      semester: "2025.#{(i%2)+1}"
    )
  end
end

class_groups.each_with_index do |cg, i|
  ClassProfessor.create!(
    professor: professors[i % professors.size],
    class_group: cg
  )
end

class_groups.each_with_index do |cg, i|
  student = students[i % students.size]
  ClassStudent.create!(
    student: student,
    class_group: cg
  )
end

templates = []
professors.each_with_index do |prof, i|
  templates << Template.create!(
    creator: prof,
    title: "Template #{i+1}",
    description: "Description for template #{i+1}"
  )
end

forms = []
class_groups.each_with_index do |cg, i|
  form = Form.create!(
    publisher: professors[i % professors.size],
    template: templates[i % templates.size],
    open_date: Date.today,
    close_date: Date.today + 10
  )
  ClassForm.create!(class_group: cg, form: form)
  forms << form
end

questions = []
forms.each_with_index do |form, i|
  q = Question.create!(
    template: form.template,
    title: "Question #{i+1}",
    description: "Description of question #{i+1}"
  )
  questions << q

  if i.even?
    3.times do |j|
      Option.create!(
        question: q,
        description: "Option #{j+1} for Q#{i+1}",
        order: j+1
      )
    end
  end
end

students.each_with_index do |student, i|
  form_ans = forms[i % forms.size]
  AnsweredForm.create!(user: student, form: form_ans)

  unanswered_forms = forms - [ form_ans ]
  if unanswered_forms.any?
    unans = unanswered_forms.sample
    puts "#{student.name} has not answered Form #{unans.id}"
  end
end

AnsweredForm.all.each do |af|
  form = af.form
  form.template.questions.each do |q|
    if q.options.any?
      Answer.create!(
        question: q,
        option: q.options.first,
        justification: "Selected option for question #{q.id}"
      )
    else
      Answer.create!(
        question: q,
        justification: "Written answer for question #{q.id}"
      )
    end
  end
end

puts "Seeding completed successfully!"
