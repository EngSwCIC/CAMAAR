# Seed de desenvolvimento — pode ser executado múltiplas vezes (idempotente).
#
# O sistema é populado com turmas, docentes e discentes através do botão de
# "Importar dados do SIGAA" (tela de administração), não pelo seed. Aqui só
# criamos a conta de administrador necessária para fazer login e disparar essa
# importação.

admin = User.find_or_create_by!(email: "admin.cic@unb.br") do |u|
  u.name         = "Admin CAMAAR"
  u.registration = "000000001"
  u.role         = :admin
  u.password     = "Senha@123"
end

puts "Seed concluída:"
puts "  Admin: #{admin.email} / Senha@123"
puts "  Use a tela 'Importar dados do SIGAA' para popular turmas, docentes e discentes."
