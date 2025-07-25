# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Cria usuários de exemplo
unless User.exists?(email: 'admin@camaar.com')
  User.create!(
    email: 'admin@camaar.com',
    password: '123456',
    password_confirmation: '123456',
    name: 'Administrador',
    matricula: '000000',
    role: :admin
  )
end

unless User.exists?(email: 'professor@camaar.com')
  User.create!(
    email: 'professor@camaar.com',
    password: '123456',
    password_confirmation: '123456',
    name: 'Professor Exemplo',
    matricula: '111111',
    role: :professor
  )
end

unless User.exists?(email: 'aluno@camaar.com')
  User.create!(
    email: 'aluno@camaar.com',
    password: '123456',
    password_confirmation: '123456',
    name: 'Aluno Exemplo',
    matricula: '222222',
    role: :aluno
  )
end

# Cria cursos de exemplo
['Engenharia de Software', 'Ciência da Computação', 'Sistemas de Informação'].each do |nome_curso|
  Curso.find_or_create_by!(nome: nome_curso)
end

# Cria disciplinas de exemplo
curso_es = Curso.find_by(nome: 'Engenharia de Software')
curso_cc = Curso.find_by(nome: 'Ciência da Computação')

disciplinas_data = [
  { nome: 'Programação Orientada a Objetos', codigo: 'POO001', curso: curso_es },
  { nome: 'Banco de Dados', codigo: 'BD001', curso: curso_es },
  { nome: 'Engenharia de Software', codigo: 'ES001', curso: curso_es },
  { nome: 'Estruturas de Dados', codigo: 'ED001', curso: curso_cc },
  { nome: 'Algoritmos', codigo: 'ALG001', curso: curso_cc },
  { nome: 'Redes de Computadores', codigo: 'RC001', curso: curso_cc }
]

disciplinas_data.each do |disciplina_data|
  Disciplina.find_or_create_by!(nome: disciplina_data[:nome]) do |disciplina|
    disciplina.codigo = disciplina_data[:codigo]
    disciplina.curso = disciplina_data[:curso]
  end
end

# Cria turmas de exemplo
professor = User.find_by(email: 'professor@camaar.com')
if professor
  disciplinas = Disciplina.all
  disciplinas.each do |disciplina|
    Turma.find_or_create_by!(
      disciplina: disciplina,
      professor: professor,
      semestre: '2025.1'
    )
  end
end

# Cria matrículas de exemplo
aluno = User.find_by(email: 'aluno@camaar.com')
if aluno
  # Matricula o aluno em algumas disciplinas
  turmas = Turma.limit(3)
  turmas.each do |turma|
    Matricula.find_or_create_by!(
      user: aluno,
      turma: turma
    )
  end
end

Rails.logger.debug 'Seeds executados com sucesso!'
Rails.logger.debug 'Usuários criados:'
Rails.logger.debug '  - admin@camaar.com (senha: 123456) - Administrador'
Rails.logger.debug '  - professor@camaar.com (senha: 123456) - Professor'
Rails.logger.debug '  - aluno@camaar.com (senha: 123456) - Aluno'
Rails.logger.debug 'Disciplinas e turmas criadas com sucesso!'
