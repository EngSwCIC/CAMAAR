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

user_attributes = {
  email: 'coordenador@gmail.com',
  password: '$2a$12$9sauXRcV/alggmsRweudU.oQv2grJQH/lq7M97PTlO7TB/2RVKNzu', #TOKEN_587
  salt: "$2a$12$9sauXRcV/alggmsRweudU.",
  created_at: Time.now,
  is_admin: true
}

user = User.find(user_attributes[:email])

if user.nil?
  user = User.new
  user.email = user_attributes[:email]
  user.salt = user_attributes[:salt]
  user.password = user_attributes[:password]
  user.created_at = user_attributes[:created_at]
  user.is_admin = user_attributes[:is_admin]
  
  if user.save
    puts "Usuário criado com sucesso!"
  else
    puts "Erro ao criar usuário: #{user.errors.full_messages.join(", ")}"
  end
else
  puts "Usuário já existe."
end
