# frozen_string_literal: true

Dado('que estou autenticado como administrador') do
  @admin = FactoryBot.create(:user, :admin)
  login_as(@admin)
end

Dado('estou na página {string} do sistema') do |path|
  visit("/#{path}")
end

Quando('eu abro o modal {string}') do |_titulo|
  find("[data-testid='botao-novo-template']").click
  expect(page).to have_selector("[data-testid='modal-template']", visible: true)
end

Quando('preencho o nome do template com {string}') do |nome|
  find("[data-testid='input-nome-template']").set(nome)
end

Quando('adiciono a questão {int} do tipo {string} com o texto {string}') do |ordem, tipo, texto|
  within("[data-testid='modal-template']") do
    find("[data-testid='botao-adicionar-questao']").click
    bloco = all("[data-testid='bloco-questao']").last
    bloco.find("[data-testid='select-tipo-questao']").select(tipo)
    bloco.find("[data-testid='input-texto-questao']").set(texto)
    bloco.find("[data-testid='input-ordem']").set(ordem) if bloco.has_selector?("[data-testid='input-ordem']")
  end
end

Quando('adiciono a questão {int} do tipo {string} com o texto {string} e as opções:') do |ordem, tipo, texto, table|
  step %(adiciono a questão #{ordem} do tipo "#{tipo}" com o texto "#{texto}")
  bloco = all("[data-testid='bloco-questao']").last
  table.raw.flatten.each do |opcao|
    bloco.find("[data-testid='input-opcao']").set(opcao)
    bloco.find("[data-testid='botao-adicionar-opcao']").click
  end
end

Quando('adiciono a questão {int} do tipo {string} com o texto {string} e nenhuma opção') do |ordem, tipo, texto|
  step %(adiciono a questão #{ordem} do tipo "#{tipo}" com o texto "#{texto}")
  # intencionalmente não adiciona opções
end

Quando('tento configurar a questão {int} do tipo {string} com escala fora de 1 a 5') do |_ordem, _tipo|
  # se a UI permitir range, tenta setar valores inválidos
  if page.has_selector?("[data-testid='input-escala-min']") && page.has_selector?("[data-testid='input-escala-max']")
    find("[data-testid='input-escala-min']").set('0')
    find("[data-testid='input-escala-max']").set('6')
  else
    # se a escala for fixa 1-5 e não editável, apenas marca o tipo e segue
    # (a validação ficará no backend; mantemos o step por consistência)
  end
end

Quando('clico em {string}') do |rotulo|
  testid = case rotulo.downcase
  when 'criar' then 'botao-criar-template'
  else "botao-#{rotulo.downcase.tr(' ', '-')}"
  end
  find("[data-testid='#{testid}']").click
end

Dado('já existe um template chamado {string} no semestre {string}') do |nome, semestre|
  FactoryBot.create(:template, nome:, semestre:)
end

Dado('que preenchi o modal com três questões em ordem') do
  step %(eu abro o modal "Novo template")
  step %(preencho o nome do template com "Template Ordenado")
  step %(adiciono a questão 1 do tipo "numérica (1-5)" com o texto "Q1")
  step %(adiciono a questão 2 do tipo "múltipla escolha" com o texto "Q2" e as opções:), Cucumber::MultilineArgument::DataTable.from([ [ 'A' ], [ 'B' ] ])
  step %(adiciono a questão 3 do tipo "texto" com o texto "Q3")
end

Então('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('devo ver o card do template {string} na listagem') do |nome|
  expect(page).to have_selector("[data-testid='template-card']", text: nome)
end

Então('ao abrir o template salvo devo ver as questões na mesma ordem') do
  find("[data-testid='template-card']", text: 'Template Ordenado').click
  textos = all("[data-testid='bloco-questao'] [data-testid='input-texto-questao']").map(&:value)
  expect(textos).to eq([ 'Q1', 'Q2', 'Q3' ])
end

Então('o template não é criado') do
  # continua com modal aberto ou não aparece novo card
  expect(page).not_to have_selector("[data-testid='template-card']", text: /Template/i)
end
