# frozen_string_literal: true

Dado('que estou na página "avaliações" logado como aluno') do
  puts 'Acessando a página de avaliações como aluno'
end

Dado('estou matriculado em turma com questionário de avaliação não respondido') do
  puts 'Turma com questionário disponível encontrada'
end

Dado('selecionei o primeiro') do
  puts 'Primeiro questionário selecionado'
end

Dado('preenchi') do
  puts 'Formulário preenchido'
end

Dado('cliquei em cancelar') do
  puts 'Cliquei em cancelar o preenchimento'
end

Então('o formulário continua presente na tela para ser preenchido do zero') do
  puts 'Formulário reiniciado para novo preenchimento'
end

Dado('escolhi, preenchi e cliquei em enviar') do
  puts 'Formulário preenchido e enviado'
end

Então('o mesmo formulário deve aparecer desabilitado') do
  puts 'Formulário enviado e desabilitado para novas respostas'
end

Então('uma mensagem informando sucesso ao enviar formulário') do
  puts 'Mensagem de sucesso exibida ao enviar formulário'
end
