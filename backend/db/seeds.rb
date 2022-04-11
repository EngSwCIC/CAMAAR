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
  subject = Subject.create(code: data['code'], name: data['name'])
  class_info = data['class']
  Cclass.create(code: class_info['classCode'], semester: class_info['semester'], time: class_info['time'], subject: subject)
end
