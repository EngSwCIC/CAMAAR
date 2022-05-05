# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
require 'json'
require 'faker'

file = File.read('./db/classes.json')
classes_data = JSON.parse(file)

for data in classes_data do
  subject = Subject.create!(code: data['code'], name: data['name'])
  class_info = data['class']
  Cclass.create!(code: class_info['classCode'], semester: class_info['semester'], time: class_info['time'], subject: subject)
end

file = File.read('./db/class_members.json')
class_members_data = JSON.parse(file)
data = class_members_data[0]
discentes = data['dicente']

cclass = Cclass.all.first

for discente in discentes do
  member = Member.create(name: discente['nome'], course: discente['curso'],
  registration: discente['matricula'], username: discente['usuario'],
  degree: discente['formacao'], occupation: discente['ocupacao'],
  email: discente['email'])
  Enrollment.create(member: member, cclass: cclass)
end

docente = data['docente']
member = Member.create(name: docente['nome'], course: docente['departamento'],
  registration: docente['usuario'], username: docente['usuario'],
  degree: docente['formacao'], occupation: docente['ocupacao'],
  email: docente['email'])
Enrollment.create(member: member, cclass: cclass)

10.times do |index|
  Survey.create(
    code: Faker::Number.number(digits: 5),
    name: Faker::TvShows::SiliconValley.invention,
    cclass: Cclass.all.sample
  )
end

10.times do |index|
  Question.create(
    code: Faker::Number.number(digits: 5),
    survey: Survey.all.sample,
    description: Faker::TvShows::Stargate.quote
  )
end

10.times do |index|
  Option.create(
    code: Faker::Number.number(digits: 5),
    question: Question.all.sample,
    description: Faker::TvShows::SiliconValley.quote,
    in_blank: [true, false].sample
  )
end

10.times do |index|
  Answer.create(
    code: Faker::Number.number(digits: 5),
    member: Member.all.sample,
    option: Option.all.sample,
    question_id: Question.all.sample
  )
end
