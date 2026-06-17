Dado("que existe um template criado") do
  @template = Template.create!(
    nome: "Modelo Antigo"
  )
end

Quando("eu edito o template") do
  visit edit_template_path(@template)
end

Quando("salvo as alterações") do
  fill_in "template_nome", with: "Modelo Novo"
  click_button "Salvar"
end

Então("uma nova versão do template deve ser criada") do
  expect(
    Template.where(nome: "Modelo Novo").count
  ).to eq(1)
end

Então("a versão anterior deve ser preservada") do
  expect(
    Template.where(nome: "Modelo Antigo").count
  ).to eq(1)
end