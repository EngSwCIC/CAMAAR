# frozen_string_literal: true

Dado('que recebi email para cadastrar-se na plataforma Camaar') do
  puts 'Email para cadastro recebido'
end

Dado('abrir o link para cadastro de primeiro acesso') do
  puts 'Link para cadastro de primeiro acesso aberto'
end

Dado('preencher a senha corretamente duas vezes') do
  puts 'Senha preenchida corretamente duas vezes'
end

Quando('clicar em "Alterar senha"') do
  puts 'Clicando em Alterar senha'
end

Então('devo ser redirecionado para a página inicial') do
  puts 'Redirecionado para a página inicial'
end

Então('uma mensagem de sucesso ser mostrada') do
  puts 'Mensagem de sucesso exibida'
end

Quando('o prazo para cadastro tiver expirado') do
  puts 'Prazo para cadastro expirado'
end

Então('uma mensagem informando que o link expirou deve ser mostrada') do
  puts 'Mensagem informando que o link expirou exibida'
end
