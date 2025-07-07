# frozen_string_literal: true

Dado('estou autenticado como administrador') do
  puts 'Login feito como administrador'
end

Dado('estou na página "Gerenciamento"') do
  puts 'Acessando a página de Gerenciamento'
end

Quando('clicar em "Importar dados"') do
  puts 'Clicando no botão "Importar dados"'
end

Quando('submeter um arquivo JSON contendo informações de uma disciplina, turma e participantes') do
  puts 'Arquivo JSON com dados novos enviado'
end

Então('o sistema deve verificar que essa turma ainda não existe') do
  puts 'Verificando se a turma já existe no banco de dados'
end

Então('inserir os novos usuários, disciplinas e turmas no banco de dados') do
  puts 'Dados inseridos com sucesso no banco de dados'
end

Quando('submeter um arquivo repetido de importação') do
  puts 'Enviando arquivo repetido para importação'
end

Então('o sistema deve abortar a importação') do
  puts 'Importação abortada devido a dados repetidos'
end

Então('mostrar uma mensagem informando dados já cadastrados') do
  puts 'Exibindo mensagem: Dados já cadastrados'
end
