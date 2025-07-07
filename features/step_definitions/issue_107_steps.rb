# frozen_string_literal: true

Dado('que estou na tela de Login') do
  puts 'Usuário está na tela de login'
end

Quando('clico em "Esqueci minha senha"') do
  puts 'Usuário clicou em "Esqueci minha senha"'
end

Quando('informo meu e-mail cadastrado') do
  puts 'Usuário informou o e-mail cadastrado'
end

Então('devo receber um e-mail com um link para redefinir a senha') do
  puts 'Sistema enviou e-mail com link para redefinição de senha'
end

Dado('que recebi o e-mail de redefinição de senha') do
  puts 'Usuário recebeu o e-mail de redefinição'
end

Dado('clico no link acessando página de redefinição de senha') do
  puts 'Usuário clicou no link e acessou página de redefinição'
end

Dado('preenchi uma nova senha válida duas vezes') do
  puts 'Usuário preencheu nova senha válida duas vezes'
end

Quando('clicar em "Alterar senha"') do
  puts 'Usuário clicou em "Alterar senha"'
end

Então('devo ser redirecionado para a tela de login com uma mensagem de confirmação') do
  puts 'Usuário foi redirecionado para login com mensagem de confirmação'
end

Dado('estou na página de redefinição de senha') do
  puts 'Usuário está na página de redefinição de senha'
end

Dado('preenchi "Confirme a senha" diferente de "Senha"') do
  puts 'Usuário preencheu campos de senha com valores diferentes'
end

Então('uma mensagem alertando que as senhas são diferentes deve ser exibida') do
  puts 'Sistema exibiu mensagem alertando que as senhas são diferentes'
end
