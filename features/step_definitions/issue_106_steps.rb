# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Administrador logado'
end

Dado('pertenço a um departamento específico') do
  puts 'Administrador pertence a um departamento específico'
end

Dado('não pertenço a um departamento específico') do
  puts 'Administrador não pertence a nenhum departamento específico'
end

Quando('acesso a seção de "Gerenciamento de Turmas"') do
  puts 'Acessando a seção de Gerenciamento de Turmas'
end

Então('devo visualizar somente as turmas vinculadas ao meu departamento') do
  puts 'Visualizando turmas do departamento do administrador'
end

Então('devo poder acessar os formulários de avaliação dessas turmas') do
  puts 'Acesso permitido aos formulários de avaliação das turmas'
end

Então('a seção de "Gerenciamento de Turmas" não deve estar habilitada') do
  puts 'Seção de Gerenciamento de Turmas não habilitada'
end
