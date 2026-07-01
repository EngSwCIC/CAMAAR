# frozen_string_literal: true

When("eu acesso a página de avaliações pendentes") do
  visit avaliacoes_pendentes_path
end

Then("devo ver o formulário da turma {string} na lista") do |nome_turma|
  expect(page).to have_content(nome_turma)
end

Then("o status do formulário deve ser {string}") do |status|
  expect(page).to have_content(status)
end

Then("devo ver uma mensagem informando que nenhum formulário pendente foi encontrado") do
  expect(page).to have_content("Nenhum formulário pendente foi encontrado.")
end

Then("não devo ver o formulário da turma {string} na lista") do |nome_turma|
  expect(page).not_to have_content(nome_turma)
end
