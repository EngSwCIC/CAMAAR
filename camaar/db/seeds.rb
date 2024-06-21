# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

# Criando um novo user

usuarios = [
  {nome: "MARISTELA TERTO DE HOLANDA",
  email: "mholanda@unb.br",
  password: 'banco_de_dados_1234?',
  usuario: "83807519491",
  formacao: "DOUTORADO",
  role: :docente},

  {nome: "fulano",
  email: "exemplo@unb.br",
  password: 'senha123',
  usuario: "000001",
  formacao: "graduando",
  role: :dicente}
]

usuarios.each do |user_data|
  user = User.create!(
    nome: user_data[:nome],
    email: user_data[:email],
    password: user_data[:password],
    usuario: user_data[:usuario],
    formacao: user_data[:formacao],
    role: user_data[:role]
  )

  if user.role == 'docente'
    Docente.create!(
      user_id: user.id,
      departamento: "DEPTO CIÊNCIAS DA COMPUTAÇÃO"
    )
  elsif user.role == 'dicente'
    Dicente.create!(
      user_id: user.id,
      curso: "CIÊNCIAS DA COMPUTAÇÃO",
      matricula: "00001"
    )
  end
end

puts "Seed de Docente criada com sucesso!"
