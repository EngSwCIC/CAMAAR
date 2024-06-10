# Require do ambiente da sua aplicação Rails
require_relative 'environment'

# Definição da classe User
class User < ActiveRecord::Base
end

# Criação da tabela User
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :email
    t.string :senha
  end
end

# Inserção de um usuário
User.create(email: 'email@unb.com.br', senha: 'password')
