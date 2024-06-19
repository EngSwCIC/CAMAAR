# frozen_string_literal: true

require 'faker'

# Constants/settings
CURRENT_YEAR = Time.now.year
YEARS = 5
TEMPLATES_PER_SEMESTER = 3

# Generate semesters for the next $YEAR years
(0..YEARS).each do |year_offset|
  year = CURRENT_YEAR + year_offset
  (1..2).each do |semester_number|
    half = semester_number == 2
    Semester.create half:, year:
  end
end

# Generate $TEMPLATES_PER_SEMESTER templates
Semester.find_each do |semester|
  TEMPLATES_PER_SEMESTER.times do
    Template.create semester:
  end
end

# Generate 1-15 questions per template
Template.find_each do |template|
  rand(1..15).times do
    Question.create template:,
                    label: Faker::Lorem.words(number: rand(3..7)).join(' '),
                    description: Faker::Lorem.paragraphs(number: rand(1..3)).join(' '),
                    input: Faker::Lorem.words(number: rand(1..3)).join(' ')
  end
end
