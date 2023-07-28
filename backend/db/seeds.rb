# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'

file = File.read('./db/classes.json')
classes_data = JSON.parse(file)

for data in classes_data do
  if (!Subject.exists?(code: data['code'], name: data['name']))
    subject = Subject.create!(code: data['code'], name: data['name'])
  else
    subject = Subject.find_by(code: data['code'])
  end
  class_info = data['class']
  Cclass.create!(code: class_info['classCode'], semester: class_info['semester'], time: class_info['time'], subject: subject)
end

file = File.read('./db/class_members.json')
class_members_data = JSON.parse(file)
data = class_members_data[0]
discentes = data['dicente']

cclass = Cclass.all.first

role_discente = Role.create(name: 'discente', description: 'discente')
# adiciona todos os discentes na primeira turma
for discente in discentes do
  member = Member.create(name: discente['nome'], course: discente['curso'],
  registration: discente['matricula'], username: discente['usuario'],
  degree: discente['formacao'],
  email: discente['email'], role: role_discente)

  senha_de_teste = '123'
  User.create(email: discente['email'], password: senha_de_teste, 
    password_confirmation: senha_de_teste, member_id: member.id)

  Enrollment.create(member: member, cclass: cclass)
end

role_docente = Role.create(name: 'docente', description: 'docente')
docente = data['docente']
member = Member.create(name: docente['nome'], course: docente['departamento'],
  registration: docente['usuario'], username: docente['usuario'],
  degree: docente['formacao'],
  email: docente['email'], role: role_docente)

senha_de_teste = '123'
User.create(email: docente['email'], password: senha_de_teste, 
    password_confirmation: senha_de_teste, member_id: member.id)

Enrollment.create(member: member, cclass: cclass)

file = File.read('./db/survey_test.json')
surveys = JSON.parse(file)

file = File.read('./db/survey_answer_test.json')
surveys_answers = JSON.parse(file)

QuestionType.create(name: "discursive")
QuestionType.create(name: "multiple_choice")
QuestionType.create(name: "likert_scale")

Survey.create(surveys)

SurveyAnswer.create(surveys_answers)