# Require do ambiente da sua aplicação Rails
require_relative 'environment'

# Definição da classe User

# Criação da tabela users caso não exista
unless ActiveRecord::Base.connection.table_exists?('users')
  ActiveRecord::Schema.define do
    create_table :users do |t|
      t.string :email
      t.string :senha

      t.timestamps
    end
  end
end

# Inserir um usuário
User.create(email: 'email@unb.com.br', senha: 'password')

# Imprimir todos os registros da tabela users
puts "Registros na tabela users:"
User.all.each do |user|
  puts user.inspect
end
