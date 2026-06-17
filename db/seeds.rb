# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin = Pessoa.find_or_create_by!(usuario: "admin") do |pessoa|
	pessoa.nome = "Admin Camaar"
	pessoa.email = "admin@camaar.local"
	pessoa.formacao = ""
	pessoa.ocupacao = ""
	pessoa.admin = true
	pessoa.password = "123456"
end

discente_pessoa = Pessoa.find_or_create_by!(usuario: "aluno") do |pessoa|
	pessoa.nome = "Aluno Demo"
	pessoa.email = "aluno@camaar.local"
	pessoa.formacao = ""
	pessoa.ocupacao = ""
	pessoa.admin = false
	pessoa.password = "123456"
end

docente_pessoa = Pessoa.find_or_create_by!(usuario: "professor") do |pessoa|
	pessoa.nome = "Prof Demo"
	pessoa.email = "professor@camaar.local"
	pessoa.formacao = ""
	pessoa.ocupacao = ""
	pessoa.admin = false
	pessoa.password = "123456"
end

discente = Discente.find_or_create_by!(pessoa_id: discente_pessoa.usuario) do |registro|
	registro.curso = "Computação"
	registro.matricula = "2026001"
end

docente = Docente.find_or_create_by!(pessoa_id: docente_pessoa.usuario) do |registro|
	registro.departamento = "Engenharia"
end

disciplina = Disciplina.find_or_create_by!(codigo: "MAT101") do |registro|
	registro.nome = "Matemática"
end

turma = Turma.find_or_create_by!(codigo: "TURMA-01") do |registro|
	registro.horario = "Segunda 10h"
	registro.semestre = "2026.1"
	registro.docente = docente
	registro.disciplina = disciplina
end

TurmaDiscente.find_or_create_by!(discente: discente, turma: turma) do |registro|
	registro.nota = nil
end

template = Template.find_or_create_by!(nome: "Avaliação Geral", pessoa_id: admin.usuario)

Formulario.find_or_create_by!(turma: turma, template: template) do |formulario|
	formulario.status = :aberto
end

formulario = Formulario.find_by!(turma: turma, template: template)

if formulario.questoes.empty?
	Questao.create!(formulario: formulario, enunciado: "Pergunta", tipo_resposta: :radio, opcoes: ["Muito bom", "Bom", "Satisfatório", "Ruim", "Péssimo"])
	Questao.create!(formulario: formulario, enunciado: "Pergunta", tipo_resposta: :texto)
	Questao.create!(formulario: formulario, enunciado: "Pergunta", tipo_resposta: :texto)
	Questao.create!(formulario: formulario, enunciado: "Pergunta", tipo_resposta: :radio, opcoes: ["Muito bom", "Bom", "Satisfatório", "Ruim", "Péssimo"])
end
