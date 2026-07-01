# db/seeds.rb
#
# CORREÇÃO: `password:` usado em vez de `senha_hash:`
# has_secure_password armazena automaticamente em `password_digest`
#
require "json"

puts "🌱 Iniciando seed do CAMAAR..."

classes_data  = JSON.parse(File.read(Rails.root.join("classes.json")))
members_data  = JSON.parse(File.read(Rails.root.join("class_members.json")))

# ── Disciplinas ──────────────────────────────────────────────────────
classes_data.each do |item|
  Disciplina.find_or_create_by!(codigo: item["code"]) do |d|
    d.nome = item["name"]
  end
end
puts "  ✓ Disciplinas: #{Disciplina.count}"

# ── Docentes, Turmas e Discentes ─────────────────────────────────────
members_data.each do |turma_data|
  disciplina   = Disciplina.find_by!(codigo: turma_data["code"])
  depto_nome   = turma_data.dig("docente", "departamento") || "Sem Departamento"
  departamento = Departamento.find_or_create_by!(nome: depto_nome)

  doc_data    = turma_data["docente"]
  usuario_doc = Usuario.find_or_create_by!(login: doc_data["usuario"]) do |u|
    u.nome           = doc_data["nome"]
    u.email          = doc_data["email"]
    u.password       = "Mudar@2024"   # ← password: correto para has_secure_password
    u.perfil         = :docente
    u.primeiro_acesso = true
  end
  docente = Docente.find_or_create_by!(usuario: usuario_doc) do |d|
    d.departamento = departamento
  end

  horario = classes_data.find { |c| c["code"] == turma_data["code"] }&.dig("class", "time")
  turma   = Turma.find_or_create_by!(codigo: turma_data["classCode"],
                                      semestre: turma_data["semester"],
                                      disciplina: disciplina) do |t|
    t.docente = docente
    t.horario = horario
  end

  turma_data["dicente"].each do |disc_data|
    usuario_disc = Usuario.find_or_create_by!(login: disc_data["usuario"]) do |u|
      u.nome           = disc_data["nome"]
      u.email          = disc_data["email"]
      u.password       = "Mudar@2024"   # ← password: correto
      u.perfil         = :discente
      u.primeiro_acesso = true
    end
    discente = Discente.find_or_create_by!(usuario: usuario_disc) do |d|
      d.matricula = disc_data["matricula"]
      d.curso     = disc_data["curso"]
    end
    Matricula.find_or_create_by!(discente: discente, turma: turma)
  end
end
puts "  ✓ Docentes: #{Docente.count}"
puts "  ✓ Discentes: #{Discente.count}"
puts "  ✓ Turmas: #{Turma.count}"
puts "  ✓ Matrículas: #{Matricula.count}"

# ── Admin ─────────────────────────────────────────────────────────────
Usuario.find_or_create_by!(login: "admin") do |u|
  u.nome           = "Administrador CAMAAR"
  u.email          = "admin@cic.unb.br"
  u.password       = "Admin@2024"   # ← password: correto
  u.perfil         = :admin
  u.primeiro_acesso = false
end
puts "  ✓ Admin criado (admin@cic.unb.br / Admin@2024)"

puts "\n✅ Seed concluído! Todos os usuários devem trocar a senha no primeiro acesso."
# Issue #13 — Login: usuários com senha já definida
User.find_or_create_by!(email: "discente@camaar.com") do |user|
  user.nome = "Discente Teste"
  user.matricula = "202400001"
  user.perfil = "Discente"
  user.password = "123456"
  user.password_confirmation = "123456"
  t.boolean "primeiro_acesso", default: true
end

User.find_or_create_by!(email: "admin@camaar.com") do |user|
  user.nome = "Administrador Teste"
  user.matricula = "000000001"
  user.perfil = "Administrador"
  user.password = "123456"
  user.password_confirmation = "123456"
  user.primeiro_acesso = false
end

# Issue #12 — Definição de senha: usuário importado sem senha
User.find_or_create_by!(email: "novo@camaar.com") do |user|
  user.nome = "Usuario Novo SIGAA"
  user.matricula = "202400099"
  user.perfil = "Discente"
  user.primeiro_acesso = true
end

# Issue #11 — Gerenciamento por departamento
departamento = Departamento.find_or_create_by!(nome: "Fábrica de Software")

admin_user = User.find_by!(email: "admin@camaar.com")
Admin.find_or_create_by!(user: admin_user, departamento: departamento)

Turma.find_or_create_by!(codigo: "FGA0001", departamento: departamento) do |turma|
  turma.nome = "Engenharia de Software"
end

Turma.find_or_create_by!(codigo: "FGA0002", departamento: departamento) do |turma|
  turma.nome = "Estrutura de Dados"
end
