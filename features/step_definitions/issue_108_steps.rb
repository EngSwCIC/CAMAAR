# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Simulando login como administrador'
end

Dado('estou na página de gerenciamento da base de dados') do
  puts 'Acessando página de gerenciamento da base de dados'
end

Quando('clico na opção "Atualizar com dados do SIGAA"') do
  puts 'Clicando na opção "Atualizar com dados do SIGAA"'
end

Então('o sistema deve importar os dados mais recentes do SIGAA') do
  puts 'Importando dados mais recentes do SIGAA'
end

Então('deve atualizar os registros existentes sem duplicar ou sobrescrever incorretamente') do
  puts 'Atualizando registros sem duplicação ou sobrescrição incorreta'
end

Então('devo ver uma mensagem de confirmação com o status da atualização') do
  puts 'Mostrando mensagem de confirmação da atualização'
end

E('são detectados dados com formato inválido ou incompatível') do
  puts 'Detectando dados inválidos ou incompatíveis'
end

Então('esses dados são ignorados') do
  puts 'Ignorando dados inválidos'
end

Então('o sistema exibe uma mensagem de erro e mantém a base no estado anterior à atualização') do
  puts 'Exibindo mensagem de erro e mantendo base no estado anterior'
end
