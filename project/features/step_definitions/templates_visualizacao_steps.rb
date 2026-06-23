# Step definitions para features/admin_ver_templates.feature (#111)

Dado("que o administrador está na interface de templates") do
  @admin = criar_admin
  @template = criar_template_com_questao(@admin, titulo: "Template do Admin #{SecureRandom.hex(4)}")

  @outro_admin = criar_admin
  @template_outro_admin = criar_template_com_questao(@outro_admin, titulo: "Template de Outro Admin #{SecureRandom.hex(4)}")

  fazer_login_como(@admin)
  visit templates_path
end

Quando("o sistema carrega os templates") do
  # A página já foi carregada no passo "Dado".
end

Então("ele deverá ver somente os templates criados por ele") do
  expect(page).to have_text(@template.title)
  expect(page).not_to have_text(@template_outro_admin.title)
end

Então("deverá ter a opção de deletar ou editar esses templates") do
  expect(page).to have_link("Editar")
  expect(page).to have_link("Deletar")
end

Quando("ele tenta acessar diretamente um template criado por outro administrador") do
  visit edit_template_path(@template_outro_admin)
end

Então("ele deverá ver uma mensagem de erro de permissão {string}") do |mensagem|
  expect(page).to have_text(mensagem)
end
