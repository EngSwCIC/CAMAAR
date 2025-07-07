Dado("que estou logado como administrador") do
  # Aqui você deve colocar o código que simula o login do administrador
  puts "Simulando login do administrador"
end

Dado("tenho algum template criado") do
  # Código para garantir que existe template criado
  puts "Template criado"
end

Dado("não possuo templates criados") do
  # Código para garantir que não existem templates
  puts "Nenhum template criado"
end

Quando("clico em {string}") do |botao|
  # Código que simula o clique em um botão
  puts "Clicando no botão #{botao}"
end

Quando("escolho um template") do
  # Código para selecionar um template
  puts "Selecionando um template"
end

Quando("seleciono turmas ou docentes") do
  # Código para seleção de turmas ou docentes
  puts "Selecionando turmas ou docentes"
end

Então("na página de avaliações deve aparecer o formulário correspondente") do
  # Código para verificar que o formulário apareceu
  puts "Verificando que o formulário apareceu"
end

Então("o botão {string} está desabilitado") do |botao|
  # Código para verificar que o botão está desabilitado
  puts "Verificando que o botão #{botao} está desabilitado"
end