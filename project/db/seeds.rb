# Seed de desenvolvimento — pode ser executado múltiplas vezes (idempotente).

# --- Departamento (sistema novo) ---
department_cic = Department.find_or_create_by!(code: "CIC") { |d| d.name = "Ciência da Computação" }
department_ene = Department.find_or_create_by!(code: "ENE") { |d| d.name = "Engenharia Elétrica" }

# --- Usuário administrador ---
admin = User.find_or_create_by!(email: "admin.cic@unb.br") do |u|
  u.name         = "Admin CAMAAR"
  u.registration = "000000001"
  u.role         = :admin
  u.password     = "Senha@123"
  u.department   = department_cic
end

# --- Usuários participantes ---
participantes = [
  { name: "Carla Mendes",    email: "carla.mendes@aluno.unb.br",   registration: "190000001", role: :participant },
  { name: "Diego Alves",     email: "diego.alves@aluno.unb.br",    registration: "190000002", role: :participant },
  { name: "Ana Souza",       email: "ana.souza@unb.br",            registration: "PROF0001",  role: :participant },
  { name: "Bruno Lima",      email: "bruno.lima@unb.br",           registration: "PROF0002",  role: :participant }
].map do |dados|
  User.find_or_create_by!(email: dados[:email]) do |u|
    u.name         = dados[:name]
    u.registration = dados[:registration]
    u.role         = dados[:role]
    u.password     = "Senha@123"
    u.department   = department_cic
  end
end

carla, diego, ana_prof, bruno_prof = participantes

# --- Turmas (CourseClass) ---
turma_ed = CourseClass.find_or_create_by!(code: "CIC0097", class_code: "T01", semester: "2026.1") do |t|
  t.name       = "Estrutura de Dados"
  t.time       = "Seg/Qua 08:00-10:00"
  t.department = department_cic
end

turma_circ = CourseClass.find_or_create_by!(code: "ENE0011", class_code: "T01", semester: "2026.1") do |t|
  t.name       = "Circuitos Elétricos"
  t.time       = "Ter/Qui 10:00-12:00"
  t.department = department_ene
end

# --- Vínculos de membros (ClassMembership) ---
ClassMembership.find_or_create_by!(user: ana_prof,  course_class: turma_ed,   role: :docente)
ClassMembership.find_or_create_by!(user: bruno_prof, course_class: turma_circ, role: :docente)
ClassMembership.find_or_create_by!(user: carla, course_class: turma_ed,   role: :discente)
ClassMembership.find_or_create_by!(user: diego, course_class: turma_ed,   role: :discente)
ClassMembership.find_or_create_by!(user: carla, course_class: turma_circ, role: :discente)

# --- Templates ---
template_discente = Template.find_or_create_by!(title: "Avaliação de Disciplina - Discentes") do |t|
  t.target_role = "discente"
  t.admin_id    = admin.id
end

if template_discente.questaos.empty?
  template_discente.questaos.create!(enunciado: "O professor demonstrou domínio do conteúdo?", tipo: "rating")
  template_discente.questaos.create!(enunciado: "O material disponibilizado foi adequado?", tipo: "rating")
  template_discente.questaos.create!(enunciado: "Comentários e sugestões para a disciplina:", tipo: "text")
end

template_docente = Template.find_or_create_by!(title: "Autoavaliação - Docentes") do |t|
  t.target_role = "docente"
  t.admin_id    = admin.id
end

if template_docente.questaos.empty?
  template_docente.questaos.create!(enunciado: "Você conseguiu cumprir o plano de ensino proposto?", tipo: "boolean")
  template_docente.questaos.create!(enunciado: "Quais dificuldades você encontrou no semestre?", tipo: "text")
end

# --- Formulário de exemplo ---
formulario = Formulario.find_or_create_by!(title: "Avaliação Estrutura de Dados - 2026.1") do |f|
  f.target_role    = template_discente.target_role
  f.admin_id       = admin.id
  f.template_id    = template_discente.id
  f.course_class_id = turma_ed.id
end

if formulario.questaos.empty?
  template_discente.questaos.each { |q| formulario.questaos.create!(enunciado: q.enunciado, tipo: q.tipo) }
end

# --- Submissão de exemplo ---
submissao = Submissao.find_or_create_by!(formulario: formulario, user: carla)

if Respostum.where(submissao_id: submissao.id).empty?
  formulario.questaos.each do |q|
    Respostum.create!(submissao_id: submissao.id, questao_id: q.id,
                      valor_numerico: (q.tipo == "rating" ? 5 : nil),
                      valor_texto:    (q.tipo != "rating" ? "Resposta de exemplo" : nil))
  end
end

puts "Seed concluída:"
puts "  Admin:        #{admin.email} / Senha@123"
puts "  Participantes: #{User.participant.count} (#{User.participant.pluck(:email).join(', ')})"
puts "  Turmas:       #{CourseClass.count}"
puts "  Templates:    #{Template.count} | Formulários: #{Formulario.count}"
puts "  Submissões:   #{Submissao.count} | Respostas: #{Respostum.count}"
