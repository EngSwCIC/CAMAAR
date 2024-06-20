# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'factory_bot_rails'

include FactoryBot::Syntax::Methods


create(:user, nome: "Admin User", email: "admin@example.com",
curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",matricula: "190084006", formacao: "doutorado", ocupacao: "docente",
password: "123456789", role: :admin, password_confirmation: "123456789",
reset_password_token: nil,
reset_password_sent_at: nil, remember_created_at: nil)
create(:user, nome: "User", email: "user@example.com",
curso: "CIÊNCIA DA COMPUTAÇÃO/CIC",
matricula: "190085006", formacao: "graduando", ocupacao: "dicente",
password: "123456",role: :user,
password_confirmation: "123456", reset_password_token: nil,
reset_password_sent_at: nil, remember_created_at: nil)


create_list(:user, 5)

# Create materias
create_list(:materia, 3)

# Create turmas with associated materias
create_list(:turma, 4) do |turma|
  turma.materia = Materia.all.sample
end

# Create templates
create_list(:template, 2)

# Create formularios with associations
create_list(:formulario, 5) do |formulario|
  # Assign random turma and template
  formulario.turma = Turma.all.sample
  formulario.template = Template.all.sample
end

# Create questoes with associations
Questao.all.each do |questao|
  # Skip creation if no formulario exists (prevents errors)
  next unless formulario = Formulario.all.sample
  questao.formulario = formulario

  # Optionally assign a random template (modify if needed)
  questao.template = Template.all.sample
end

# Create respostas with associations
Resposta.all.each do |resposta|
  # Skip creation if no questao exists (prevents errors)
  next unless questao = Questao.all.sample
  resposta.questao = questao
end

create_list(:matricula, 3) do |matricula|
  # Assign random user and turma
  matricula.user = User.all.sample
  matricula.turma = Turma.all.sample
end
