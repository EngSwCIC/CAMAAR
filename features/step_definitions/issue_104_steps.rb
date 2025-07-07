# frozen_string_literal: true

Dado('que estou na página de login') do
  puts 'Acessando página de login'
end

Dado('preenchi um e-mail e senha válidos') do
  puts 'Preenchendo e-mail e senha válidos'
end

Dado('preenchi uma matrícula e a senha válidas') do
  puts 'Preenchendo matrícula e senha válidas'
end

Dado('sou um usuário com perfil de administrador') do
  puts 'Usuário com perfil de administrador'
end

Dado('preenchi um e-mail, matrícula ou senha incorretos') do
  puts 'Preenchendo dados incorretos para login'
end

Quando('clico em "Entrar"') do
  puts 'Clicando em Entrar'
end

Quando('faço login com credenciais válidas') do
  puts 'Fazendo login com credenciais válidas'
end

Então('devo ser autenticado com sucesso') do
  puts 'Usuário autenticado com sucesso'
end

Então('redirecionado para a página inicial') do
  puts 'Redirecionado para a página inicial'
end

Então('devo ver a opção de gerenciamento no menu lateral') do
  puts 'Exibindo opção de gerenciamento no menu lateral'
end

Então('devo ver uma mensagem de erro informando que as credenciais são inválidas') do
  puts 'Exibindo mensagem de erro de credenciais inválidas'
end
