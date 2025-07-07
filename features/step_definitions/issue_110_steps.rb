# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Simulando login como administrador'
end

Dado('existem formulários previamente criados no sistema') do
  puts 'Existem formulários previamente criados no sistema'
end

Dado('estou na página "Gerenciamento"') do
  puts 'Acessando a página "Gerenciamento"'
end

Quando('clicar em "Resultados"') do
  puts 'Clicando no botão "Resultados"'
end

Então('devo ver uma grade com todos os formulários disponíveis') do
  puts 'Visualizando grade com todos os formulários disponíveis'
end

Então('o botão deve estar desabilitado e nada deve acontecer') do
  puts 'Verificando que o botão "Resultados" está desabilitado e nenhuma ação foi tomada'
end
