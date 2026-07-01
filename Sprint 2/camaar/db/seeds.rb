# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.find_or_create_by!(email: "admin@unb.br") do |user|
  user.name = "Administrador"
  user.matricula = "123456789"
  user.role = "admin"
  user.password = "123456"
  user.password_confirmation = "123456"
  user.first_access = false
end

User.find_or_create_by!(email: 'usuario@unb.br') do |user|
  user.name = 'Usuário Teste'
  user.matricula = '000000002'
  user.role = 'user'
  user.password = '123456'
  user.password_confirmation = '123456'
  user.first_access = false
end