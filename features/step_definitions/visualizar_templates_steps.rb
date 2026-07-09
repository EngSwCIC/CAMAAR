require "securerandom"

Dado("que eu estou logado no sistema CAMAAR com o perfil de {string}") do |perfil|
  Capybara.current_driver = :rack_test

  perfil_normalizado = perfil.downcase == "administrador" ? "Administrador" : "Discente"

  @usuario = User.create!(
    nome: "#{perfil_normalizado} Teste",
    email: "#{perfil_normalizado.downcase}_#{SecureRandom.hex(4)}@camaar.com",
    matricula: SecureRandom.random_number(99_999_999).to_s,
    perfil: perfil_normalizado,
    password: "123456",
    password_confirmation: "123456"
  )

  page.driver.submit :post, login_path, {
    identifier: @usuario.email,
    password: "123456"
  }

  expect(page).to have_no_content("Usuário e/ou senha inválidos")
end

Dado("que os seguintes templates estão cadastrados no sistema:") do |table|
  table.hashes.each do |template|
    @usuario.templates.create!(
      nome: template["nome"],
      semestre: template["semestre"]
    )
  end
end

Dado("não há nenhum template cadastrado no sistema") do
  Template.delete_all
end

Quando("eu acesso a página de gerenciamento de templates") do
  visit templates_path
end

Quando("eu acesso a URL de gerenciamento de templates") do
  visit templates_path
end

Então("eu devo ver uma grade com os templates cadastrados") do
  expect(page).to have_css(".templates-grid")
  expect(page).to have_css(".template-card", count: @usuario.templates.count)
end

Então("cada card deve exibir o nome, o semestre, o ícone de editar e o ícone de deletar") do
  @usuario.templates.each do |template|
    expect(page).to have_content(template.nome)
    expect(page).to have_content(template.semestre)
  end

  all(".template-card").each do |card|
    expect(card).to have_css('[aria-label="Editar template"]')
    expect(card).to have_css('[aria-label="Deletar template"]')
  end
end

Então("eu não devo ver nenhum card de template na grade") do
  expect(page).to have_no_css(".template-card")
end

Então("eu devo ver apenas a opção de criação de um novo template") do
  expect(page).to have_content("Apenas a opção de criação de um novo template está disponível.")
end

Então("o sistema deve exibir a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Então("eu devo ser redirecionado para a página inicial do meu perfil") do
  expect(page).to have_current_path(discente_dashboard_path)
end
