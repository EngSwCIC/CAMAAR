# Limpa os usuários existentes (apenas em desenvolvimento)
if Rails.env.development?
  User.destroy_all

  # Usuário regular (discente)
  User.create!(
    nome: "Aluno Teste",
    email: "aluno@teste.com",
    matricula: "012345678",
    password: "12345678",
    password_confirmation: "12345678",
    ocupacao: "discente",
    curso: "Ciência da Computação"
  )

  # Usuário admin
  User.create!(
    nome: "Admin Teste",
    email: "admin@teste.com",
    password: "12345678",
    password_confirmation: "12345678",
    ocupacao: "admin"
  )

  puts "Usuários criados:"
  puts "Aluno: aluno@teste.com / 12345678"
  puts "Admin: admin@teste.com / 12345678"
end
