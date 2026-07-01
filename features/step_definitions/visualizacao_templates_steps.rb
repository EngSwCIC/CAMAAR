Dado("que existem templates cadastrados no sistema") do
  Template.create!(
    nome: "Relatório da Disciplina"
  )

  Template.create!(
    nome: "Avaliação Final"
  )
end

Dado("existem templates cadastrados no sistema") do
  step "que existem templates cadastrados no sistema"
end

Dado("que não existem templates cadastrados no sistema") do
  Template.destroy_all
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

Dado("que não estou autenticado") do
  page.driver.submit(:delete, logout_path, {}) if page.current_path != login_path
end

Quando("acesso a página de templates") do
  if defined?(@simulate_template_error) && @simulate_template_error
    visit templates_path(simulate_error: true)
  else
    visit templates_path
  end
end

Quando("tento acessar a página de templates") do
  visit templates_path
end

Então("devo ser redirecionado para a página de login") do
  expect(page).to have_current_path(login_path, ignore_query: true)
end

Então("devo ser impedido de acessar a página") do
  expect(page).to have_text(/Acesso não autorizado|Acesso negado/)
end

Quando("ordeno os templates por nome em ordem alfabética") do
  visit templates_path
end

Então("devo ver os templates ordenados por nome") do
  page_text = page.body
  expect(page_text.index("Avaliação Final")).to be < page_text.index("Relatório da Disciplina")
end

Dado("que existem muitos templates cadastrados no sistema") do
  Template.destroy_all
  12.times do |i|
    Template.create!(nome: "Template #{format('%02d', i + 1)}")
  end
end

Então("devo ver os templates divididos em páginas") do
  expect(page).to have_link("Próxima")
  expect(page).to have_selector("ul li", count: 5)
end

Então("devo poder navegar entre páginas") do
  click_link "Próxima"
  expect(page).to have_link("Anterior")
end

Dado("que ocorre uma falha no servidor") do
  @simulate_template_error = true
end


Então("devo ver uma mensagem de erro ao carregar os templates") do
  expect(page).to have_text("Erro ao carregar a lista de templates")
end

Dado("que o template foi excluído") do
  @deleted_template = Template.create!(nome: "Template Excluído")
  @deleted_template.destroy!
end

Quando("tento acessá-lo diretamente") do
  visit template_path(@deleted_template.id)
end

Então("devo ver uma mensagem informando que o template não existe") do
  expect(page).to have_text("Template não encontrado.")
end
