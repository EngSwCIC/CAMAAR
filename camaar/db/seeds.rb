# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:

# Criar uma nova instância de Dicente
dicente = Dicente.new(
  nome: 'Fulano',
  email: 'fulano@example.com',
  password: 'senha123',
  type: 'Dicente',
  usuario: 'fulano',
  formacao: 'Bacharelado',
  matricula: '0001',
  curso: 'Engenharia de Software'
)

# Salvar o dicente no banco de dados
dicente.save!
