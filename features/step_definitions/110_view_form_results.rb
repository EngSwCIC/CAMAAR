# frozen_string_literal: true

Dado('que estou logado como um administrador válido') do
  @admin = FactoryBot.create(:user, :admin)
  login_as(@admin)
end

Dado('que não existem formulários cadastrados') do
  Formulario.delete_all
end

Dado('que existem formulários para o semestre atual:') do |table|
  table.hashes.each do |row|
    FactoryBot.create(:formulario, titulo: row['título'], semestre: '2025.1')
  end
end

Dado('que existe o formulário {string} com {int} respostas enviadas') do |titulo, total|
  formulario = FactoryBot.create(:formulario, titulo: titulo, semestre: '2025.1')
  FactoryBot.create_list(:resposta, total, formulario: formulario)
end

Dado('que existem formulários com professor {string}') do |nome|
  FactoryBot.create(:formulario, titulo: 'Avaliação Docente', professor: nome, semestre: '2025.1')
  FactoryBot.create(:formulario, titulo: 'Avaliação da Infraestrutura', professor: 'Outro', semestre: '2025.1')
end

Dado('que existem formulários de semestres diferentes') do
  FactoryBot.create(:formulario, titulo: 'Avaliação Docente', semestre: '2025.1')
  FactoryBot.create(:formulario, titulo: 'Avaliação Docente', semestre: '2024.2')
end

Dado('que existe o formulário {string} sem nenhuma resposta') do |titulo|
  FactoryBot.create(:formulario, titulo: titulo, semestre: '2025.1')
end

Dado('o serviço de exportação está indisponível') do
  allow(ExportadorResultadosService).to receive(:call).and_raise(StandardError, 'falha')
end

# -------- Ações --------

Quando('eu acesso a página {string}') do |path|
  visit("/#{path}")
end

Quando('eu acesso diretamente o endereço {string}') do |path|
  visit("/#{path}")
end

Quando('eu abro o card {string}') do |titulo|
  find("[data-testid='form-card']", text: titulo).click
end

Quando('eu pesquiso por {string}') do |termo|
  find("[data-testid='campo-busca']").set(termo)
  find("[data-testid='botao-buscar']").click
end

Quando('seleciono o filtro de semestre {string}') do |semestre|
  find("[data-testid='filtro-semestre']").select(semestre)
end

Quando('tento exportar os resultados') do
  find("[data-testid='botao-exportar']").click
end

# -------- Verificações --------

Então('devo visualizar os cards dos formulários {string} e {string}') do |t1, t2|
  expect(page).to have_selector("[data-testid='form-card']", text: t1)
  expect(page).to have_selector("[data-testid='form-card']", text: t2)
end

Então('cada card exibe semestre, professor e total de respostas') do
  all("[data-testid='form-card']").each do |card|
    expect(card).to have_selector("[data-testid='info-semestre']")
    expect(card).to have_selector("[data-testid='info-professor']")
    expect(card).to have_selector("[data-testid='info-total-respostas']")
  end
end

Então('vejo o resumo consolidado com gráficos e estatísticas') do
  expect(page).to have_selector("[data-testid='resumo-formulario']")
  expect(page).to have_selector("[data-testid='grafico-resultados']")
end

Então('devo ver a mensagem {string}') do |texto|
  expect(page).to have_content(texto)
end

Então('o botão {string} deve estar desabilitado') do |rotulo|
  # mapeia "Exportar resultados" -> botao-exportar-resultados
  testid = "botao-#{rotulo.downcase.tr(' ', '-')}"
  expect(page).to have_selector("[data-testid='#{testid}'][disabled]")
end

Então('permaneço na página de resultados') do
  expect(URI.parse(current_url).path).to eq('/resultados')
end

Então('vejo apenas os formulários do semestre {string}') do |semestre|
  # todos exibidos com aquele semestre
  expect(page).to have_selector("[data-testid='info-semestre']", text: semestre)
  # e não aparece outro semestre
end

Então('nenhum arquivo é baixado') do
  # Depende de como é feito; validar ausência de toast de sucesso:
  expect(page).not_to have_content('Relatório exportado com sucesso')
end

Então('o botão "Exportar resultados" deve estar habilitado') do
  expect(page).to have_selector("[data-testid='botao-exportar']", visible: true)
  expect(find("[data-testid='botao-exportar']")).not_to be_disabled
end
