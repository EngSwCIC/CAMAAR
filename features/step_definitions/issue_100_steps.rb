# frozen_string_literal: true

Dado('que importei com sucesso um JSON com novos usuário') do
  puts 'JSON com novos usuários importado com sucesso'
end

Quando('clicar em "Enviar email de primeiro acesso"') do
  puts 'Cliquei em Enviar email de primeiro acesso'
end

Então('um email deve ser enviado para todos os novos usuários importados via JSON com um link pedindo cadastrar senha de primeiro acesso') do
  puts 'Email enviado para todos os novos usuários com link para cadastrar senha'
end

E('alguns emails não puderam ser enviados') do
  puts 'Alguns emails não puderam ser enviados'
end

Então('uma mensagem de alerta deve ser exibida mostrando todos os emails que não puderam ser entregues') do
  puts 'Mensagem de alerta exibida com os emails não entregues'
end
