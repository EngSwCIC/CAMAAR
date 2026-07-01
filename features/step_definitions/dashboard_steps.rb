# frozen_string_literal: true

require "json"

def search_suggestion_of_type(type, title)
  estado.fetch(:sugestoes_pesquisa).find do |suggestion|
    suggestion.fetch("tipo") == type && suggestion.fetch("titulo") == title
  end
end

When(/^acesso a tela inicial$/) do
  visit avaliacoes_path
end

When(/^pesquiso por "([^"]+)"$/) do |termo|
  visit pesquisa_path(q: termo)
end

When(/^consulto as sugestões de pesquisa por "([^"]+)"$/) do |termo|
  visit sugestoes_pesquisa_path(q: termo)
  estado[:sugestoes_pesquisa] = JSON.parse(page.body)
end

Then(/^devo ver a saudação do usuário autenticado$/) do
  expect(page).to have_content("Olá, #{usuario_atual.nome}")
end

Then(/^devo ver a avaliação pendente da turma "([^"]+)" no painel inicial$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)

  expect(page).to have_content(turma.nome_exibicao)
  expect(page).to have_content("Não respondido")
end

Then(/^não devo ver a área de administração no painel inicial$/) do
  expect(page).to have_no_content("Administração")
  expect(page).to have_no_link("Abrir gerenciamento")
end

Then(/^devo ver a área de administração no painel inicial$/) do
  expect(page).to have_content("Administração")
  expect(page).to have_link("Abrir gerenciamento", href: gerenciamento_path)
end

Then(/^devo ver o link de gerenciamento no menu lateral$/) do
  expect(page).to have_link("Gerenciamento", href: gerenciamento_path)
end

Then(/^devo ver resultados de avaliações pendentes para "([^"]+)"$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)

  expect(page).to have_content("Avaliações pendentes")
  expect(page).to have_content(turma.nome_exibicao)
end

Then(/^não devo ver resultados administrativos na pesquisa$/) do
  expect(page).to have_no_content("Templates")
  expect(page).to have_no_content("Formulários")
end

Then(/^devo ver resultados de templates para "([^"]+)"$/) do |titulo|
  expect(page).to have_content("Templates")
  expect(page).to have_link(titulo)
end

Then(/^devo ver resultados de formulários para a turma "([^"]+)"$/) do |turma_nome|
  turma = turma_com_identificador(turma_nome)

  expect(page).to have_content("Formulários")
  expect(page).to have_content(turma.nome_exibicao)
end

Then(/^devo receber uma sugestão de turma "([^"]+)"$/) do |titulo|
  estado[:ultima_sugestao_turma] = search_suggestion_of_type("Turma", titulo)

  expect(estado[:ultima_sugestao_turma]).to be_present
end

Then(/^a sugestão de turma deve restringir a pesquisa sem templates$/) do
  query = Rack::Utils.parse_nested_query(
    URI.parse(estado.fetch(:ultima_sugestao_turma).fetch("url")).query
  )

  expect(query.fetch("sem_templates")).to eq("1")
  expect(query.fetch("tipos")).not_to include("templates")
  expect(query.fetch("turma_id")).to be_present
end

Then(/^devo receber uma sugestão de template "([^"]+)"$/) do |titulo|
  expect(search_suggestion_of_type("Template", titulo)).to be_present
end

Then(/^o menu do usuário deve estar configurado para fechar ao clicar fora$/) do
  expect(page).to have_css(
    ".user-dropdown[data-controller='user-menu'][data-action*='click@window->user-menu#closeFromOutside']"
  )
end
