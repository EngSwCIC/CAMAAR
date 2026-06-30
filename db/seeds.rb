# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Templates de exemplo para a busca (issue #1)
avaliacao = Template.find_or_create_by!(nome: "Avaliação de Disciplina") do |t|
  t.descricao = "Template padrão para avaliação de disciplinas pelos discentes."
  t.publico_alvo = "discente"
end
avaliacao.questions.find_or_create_by!(enunciado: "Como você avalia a disciplina?") do |q|
  q.tipo = "multipla_escolha"
  q.opcoes = "Excelente\nBoa\nRegular\nRuim"
end
avaliacao.questions.find_or_create_by!(enunciado: "Deixe sugestões para a disciplina.") do |q|
  q.tipo = "discursiva"
end

Template.find_or_create_by!(nome: "Avaliação de Docente") do |t|
  t.descricao = "Template para avaliação de desempenho docente."
  t.publico_alvo = "discente"
end

# Usuários de demonstração (senha já definida, prontos para login)
admin = User.find_or_create_by!(email: "admin@camaar.com") do |u|
  u.nome = "Administrador"
  u.matricula = "000000000"
  u.perfil = "docente"
  u.departamento = "CIC"
  u.password = "password123"
  u.password_confirmation = "password123"
end

aluno = User.find_or_create_by!(email: "aluno@camaar.com") do |u|
  u.nome = "Aluno Demonstração"
  u.matricula = "190000000"
  u.perfil = "discente"
  u.password = "password123"
  u.password_confirmation = "password123"
end

aluno2 = User.find_or_create_by!(email: "aluno2@camaar.com") do |u|
  u.nome = "Aluno 2"
  u.matricula = "190000001"
  u.perfil = "discente"
  u.password = "password123"
  u.password_confirmation = "password123"
end

# Turma de exemplo (issue #4) e matrículas (issues #4/#8)
turma = Turma.find_or_create_by!(code: "CIC0105", class_code: "TA", semester: "2021.2") do |t|
  t.name = "ENGENHARIA DE SOFTWARE"
  t.time = "35M12"
  t.departamento = "CIC"
end

Enrollment.find_or_create_by!(user: admin, turma: turma) { |e| e.role = "docente" }
Enrollment.find_or_create_by!(user: aluno, turma: turma) { |e| e.role = "discente" }
Enrollment.find_or_create_by!(user: aluno2, turma: turma) { |e| e.role = "discente" }

# Formulário de exemplo gerado a partir do template (issue #7)
Formulario.find_or_create_by!(template: avaliacao, turma: turma) do |f|
  f.titulo = "Avaliação de Disciplina - Engenharia de Software"
end

# Resposta de exemplo (issue #8)
Resposta.find_or_create_by!(formulario: Formulario.first, question: avaliacao.questions.first, user: aluno2) do |r|
  r.valor = "Excelente"
end
