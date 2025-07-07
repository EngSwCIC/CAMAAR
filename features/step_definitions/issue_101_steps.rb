# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Logado como administrador'
end

Dado('entrei na página "Gerenciamento"') do
  puts 'Acessando página Gerenciamento'
end

Dado('cliquei no botão "Resultados"') do
  puts 'Cliquei no botão Resultados'
end

Quando('clicar em um dos formulários mostrados na grade') do
  puts 'Cliquei em um formulário na grade'
end

Então('um arquivo CSV deve ser gerado') do
  puts 'Arquivo CSV gerado'
end

Então('uma mensagem de confirmação com botão "Baixar resultados" deve aparecer') do
  puts 'Mensagem de confirmação exibida com botão Baixar resultados'
end

Então('uma mensagem alertando "Formulário ainda está aberto! Tem certeza que deseja baixar o relatório?" deve aparecer') do
  puts 'Mensagem de alerta sobre formulário aberto exibida'
end

Dado('que apareceu uma mensagem alertando "Formulário ainda está aberto! Tem certeza que deseja baixar o relatório?" deve aparecer') do
  puts 'Mensagem de alerta sobre formulário aberto aparece'
end

Dado('clico em "Sim, baixar relatório incompleto"') do
  puts 'Cliquei em Sim, baixar relatório incompleto'
end
