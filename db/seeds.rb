User.find_or_create_by!(email: "discente@camaar.com") do |user|
  user.nome = "Discente Teste"
  user.matricula = "202400001"
  user.perfil = "Discente"
  user.password = "123456"
  user.password_confirmation = "123456"
end

User.find_or_create_by!(email: "admin@camaar.com") do |user|
  user.nome = "Administrador Teste"
  user.matricula = "000000001"
  user.perfil = "Administrador"
  user.password = "123456"
  user.password_confirmation = "123456"
end