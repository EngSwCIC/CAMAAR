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

cclass_1 = Cclass.all.first
cclass_3 = Cclass.all.find(3)

# adiciona todos os discentes na primeira turma
for discente in discentes do
  member = Member.create(name: discente['nome'], course: discente['curso'],
  registration: discente['matricula'], username: discente['usuario'],
  degree: discente['formacao'], occupation: discente['ocupacao'],
  email: discente['email'])
  Enrollment.create(member: member, cclass: cclass_1)
end

docente_1 = data['docente'][0]
member_1 = Member.create(name: docente_1['nome'], course: docente_1['departamento'],
  registration: docente_1['usuario'], username: docente_1['usuario'],
  degree: docente_1['formacao'], occupation: docente_1['ocupacao'],
  email: docente_1['email'])
Enrollment.create(member: member_1, cclass: cclass_1)

docente_2 = data['docente'][1]
member_2 = Member.create(name: docente_2['nome'], course: docente_2['departamento'],
  registration: docente_2['usuario'], username: docente_2['usuario'],
  degree: docente_2['formacao'], occupation: docente_2['ocupacao'],
  email: docente_2['email'])
Enrollment.create(member: member_2, cclass: cclass_3)
