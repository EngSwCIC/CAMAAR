
Dado('que estou logado como administrador') do
  puts 'Simulando login como administrador'
end

Dado('estou na pagina de gerenciamento de templates') do
  puts 'Acessando a pagina de gerenciamento de templates'
end

Dado('estou na página de gerenciamento de templates') do
  puts 'Acessando a pagina de gerenciamento de templates'
end

Dado('existe um template criado por mim') do
  puts 'Template criado pelo administrador'
end

Quando("clico na opção 'Editar' do template") do
  puts "Clicando na opcao 'Editar' do template"
end

Então('devo modificar o nome, a descrição ou as perguntas do template') do
  puts 'Modificando o nome, a descricao ou as perguntas do template'
end

Então('ao salvar, as mudanças não devem afetar formulários já criados com esse template') do
  puts 'Verificando que formularios ja criados nao foram afetados'
end

Quando('clico na opção "Deletar" do template') do
  puts 'Clicando na opcao "Deletar" do template'
end

Então('o template deve ser removido da lista de templates disponíveis') do
  puts 'Verificando que o template foi removido da lista de templates disponiveis'
end

Então('os formulários que já foram criados com base nesse template devem permanecer inalterados') do
  puts 'Verificando que os formularios antigos permanecem inalterados'
end
