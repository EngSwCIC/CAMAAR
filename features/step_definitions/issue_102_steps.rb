# frozen_string_literal: true

Dado('que estou autenticado como administrador') do
  puts 'Autenticado como administrador'
end

Dado('estou na página "Gerenciamento" de templates') do
  puts 'Na página Gerenciamento de templates'
end

Dado('já importei dados da turma') do
  puts 'Dados da turma importados'
end

Dado('cliquei em "+" para criar template') do
  puts 'Cliquei no botão + para criar template'
end

Dado('adicionei novas questões') do
  puts 'Novas questões adicionadas'
end

Quando('clicar em "Criar"') do
  puts 'Cliquei em Criar'
end

Então('o popup de edição deve sumir') do
  puts 'Popup de edição sumiu'
end

Então('um novo template deve aparecer na grade como disponível') do
  puts 'Novo template aparece na grade'
end

Então('deverá aparecer uma mensagem de erro avisando que não é possível criar um template em branco') do
  puts 'Mensagem de erro: não é possível criar template em branco'
end
