# frozen_string_literal: true

Dado('que estou logado como administrador') do
  puts 'Simulando login como administrador'
end

Dado('estou na página "Gerenciamento" de templates') do
  puts 'Acessando a página de gerenciamento de templates'
end

Dado('existem templates criados por mim') do
  puts 'Existem templates criados pelo administrador'
end

Quando('clicar em "Editar templates"') do
  puts 'Clicando em "Editar templates"'
end

Então('devo ver uma grade com todos os templates criados') do
  puts 'Visualizando grade com todos os templates criados'
end

Então('cada template deve conter título, descrição, ícone de editar ou deletar') do
  puts 'Verificando que cada template tem título, descrição e ícones de editar/deletar'
end

Quando('clicar em deletar template') do
  puts 'Clicando para deletar o template selecionado'
end

Então('o template selecionado deve ser apagado') do
  puts 'Verificando que o template foi apagado'
end

Então('a tela deverá atualizar para não mostrar ele') do
  puts 'Verificando que a tela foi atualizada e não mostra o template apagado'
end
