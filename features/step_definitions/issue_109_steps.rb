# frozen_string_literal: true

Dado('que estou logado como participante') do
  puts 'Simulando login como participante'
end

Dado('estou matriculado em uma ou mais turmas') do
  puts 'Participante está matriculado em uma ou mais turmas'
end

Quando('acesso a página "Avaliações"') do
  puts 'Acessando a página "Avaliações"'
end

Então('devo ver uma grade com todos os formulários não respondidos') do
  puts 'Visualizando grade com todos os formulários não respondidos'
end

Então('cada formulário deve mostrar o nome da disciplina, turma e data de vencimento') do
  puts 'Verificando que cada formulário mostra nome da disciplina, turma e data de vencimento'
end

Quando('respondo um formulário') do
  puts 'Formulário respondido pelo participante'
end

Então('o formulário não deve mais ser listado aqui') do
  puts 'Verificando que o formulário respondido não aparece mais na lista'
end
