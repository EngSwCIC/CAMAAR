Dado('que existem os seguintes templates cadastrados no sistema:') do |table|
  @admin = Pessoa.find_or_create_by!(usuario: "admin_templates") do |p|
    p.email = "admin_templates@unb.br"
    p.password = "senha123"
    p.password_confirmation = "senha123"
    p.nome = "Administrador de Templates"
    p.admin = true
  end

  table.hashes.each do |row|
    Template.create!(
      nome: row['titulo'], 
      pessoa: @admin
    )
  end
end

Dado('que estou logado como um usuário Administrador') do
  @admin ||= Pessoa.find_or_create_by!(usuario: "admin_templates") do |p|
    p.email = "admin_templates@unb.br"
    p.password = "senha123"
    p.password_confirmation = "senha123"
    p.nome = "Administrador de Templates"
    p.admin = true
  end

  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: "senha123"
  click_button 'Entrar'
end

Quando('acesso a página de gerenciamento de templates') do
  visit admin_templates_path
end

Então('devo ver uma lista contendo todos os templates cadastrados') do
  expect(page).to have_css('body')
end

Então('devo visualizar o template {string}') do |titulo_template|
  expect(page).to have_content(titulo_template)
end

Dado('que não existem templates cadastrados no sistema') do
  Template.destroy_all
end

Então('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end