Dado("que existem templates cadastrados no sistema") do
  Template.create!(
    nome: "Relatório da Disciplina"
  )

  Template.create!(
    nome: "Avaliação Final"
  )
end

Dado("que não existem templates cadastrados no sistema") do
  Template.destroy_all
end

Quando("acesso a página de templates") do
  visit templates_path
end

Então("devo ver a lista de templates criados") do
  expect(page).to have_content("Relatório da Disciplina")
  expect(page).to have_content("Avaliação Final")
end

Então("devo poder selecionar um template para visualizar, editar ou excluir") do
  expect(page).to have_link("Visualizar")
  expect(page).to have_link("Editar")
  expect(page).to have_link("Excluir")
end

Então("devo ver uma mensagem informando que não há templates disponíveis") do
  expect(page).to have_content("Não há templates disponíveis")
end

Quando(
  'busco o template pelo nome {string}'
) do |nome|
  visit templates_path(q: nome)
end

Então(
  "devo ver apenas os templates correspondentes à busca"
) do
  expect(page).to have_content(
    "Relatório da Disciplina"
  )
end

Quando("seleciono um template da lista") do
  visit template_path(Template.first)
end

Então("devo ver os detalhes do template") do
  expect(page).to have_content(
    Template.first.nome
  )
end