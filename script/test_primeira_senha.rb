# Script para testar a funcionalidade de primeira senha
# Executa no console do Rails: rails console

# Criar um usuário de teste sem senha
user_test = User.new(
  name: 'Usuario Teste Primeira Senha',
  email: 'teste.primeira.senha@camaar.com',
  matricula: '123456789',
  role: 'aluno'
)

# Salvar sem validação de senha (bypass do Devise)
user_test.save(validate: false)

puts 'Usuário criado:'
puts "Nome: #{user_test.name}"
puts "Email: #{user_test.email}"
puts "Matrícula: #{user_test.matricula}"
puts "Tem senha? #{!user_test.sem_senha?}"
puts "Senha criptografada: #{user_test.encrypted_password.inspect}"

# Para testar, acesse: http://localhost:3000/primeira_senha
# Use:
# Matrícula: 123456789
# Email: teste.primeira.senha@camaar.com
