# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

# Criando um novo user
user = User.find_or_create_by!(
  nome: 'fulano',
  email: 'fulano@egmail.com',
  password: 'senha1234',
  usuario: 'usuario123',
  formacao: 'graduação'
)

# Criando um novo Dicente
Dicente.find_or_create_by!(
  user_id: user.id,
  matricula: '00001'
)

puts "Seed de Dicente criada com sucesso!"
