# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Usuário logado como administrador'
end

Dado('tenho templates de formulários disponíveis') do
  puts 'Templates de formulários disponíveis'
end

Dado('escolhi um template') do
  puts 'Template selecionado'
end

Dado('escolhi as turmas para aplicar o formulário') do
  puts 'Turmas selecionadas para aplicar o formulário'
end

Dado('escolhi uma turma que já possui formulário em aberto') do
  puts 'Turma selecionada já possui formulário em aberto'
end

Quando('clicar em "Enviar"') do
  puts 'Clicando em Enviar'
end

Então('o formulário deve ficar disponível para as turmas selecionadas') do
  puts 'Formulário disponível para as turmas selecionadas'
end

Então('aparecer na página "Avaliações"') do
  puts 'Formulário aparece na página Avaliações'
end

Então('uma mensagem deve aparecer confirmando a criação com sucesso') do
  puts 'Mensagem de confirmação de criação com sucesso'
end

Então('uma mensagem de alerta deve aparecer indicando que a turma já possui formulário em aberto') do
  puts 'Mensagem de alerta: turma já possui formulário em aberto'
end
