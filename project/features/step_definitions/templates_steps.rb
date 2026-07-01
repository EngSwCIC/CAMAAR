# Step definitions para features/admin_criar_template.feature (#102)
# Alguns passos abaixo são reutilizados por features/admin_editar_deletar_templates.feature (#112).

Dado("que estou na página de criar template") do
  @admin = criar_admin
  fazer_login_como(@admin)
  visit new_template_path
end

Quando("eu preencho o campo 'Nome do template:'") do
  @template_title = "Template Avaliação #{SecureRandom.hex(4)}"
  fill_in "template[title]", with: @template_title
end

Quando("eu deixo o campo 'Nome do template:' vazio") do
  # O campo é deliberadamente deixado em branco.
end

Quando("clico no botão '+'") do
  click_button "+"
end

Quando("seleciono o 'Público-alvo:'") do
  select "Discentes", from: "template[target_role]"
end

Quando("preencho o campo 'Enunciado da questão:'") do
  fill_in "template[questaos][0][enunciado]", with: "Qual é a capital do Brasil?"
end

Quando("não preencho o campo 'Enunciado da questão:'") do
  # O campo é deliberadamente deixado em branco.
end

Quando("adiciono uma questão válida") do
  click_button "+"
  fill_in "template[questaos][0][enunciado]", with: "Qual é a maior montanha do mundo?"
end

Quando("clico no botão 'Criar'") do
  click_button "Criar"
end

Então("o novo template deve aparecer na tela de meus templates") do
  expect(page).to have_text(@template_title)
end

Então("deve aparecer uma mensagem 'O nome do template é obrigatório'") do
  expect(page).to have_text("O nome do template é obrigatório")
end

Então("deve aparecer uma mensagem 'Questão não possui enunciado'") do
  expect(page).to have_text("Questão não possui enunciado")
end
