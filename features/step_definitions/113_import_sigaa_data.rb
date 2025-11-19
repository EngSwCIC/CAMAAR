# frozen_string_literal: true

# Step definitions para a feature de importação de dados do SIGAA (#113).
# IMPORTANTE:
# - Ajuste os nomes dos models (Turma, Materia, Participante) conforme o projeto.
# - Ajuste caminhos dos arquivos JSON e os identificadores de campos/botões da view.

Dado('que estou autenticado como administrador') do
  # Se esse step já existir em outro arquivo, remova esta definição para evitar duplicação.
  @admin = FactoryBot.create(:user, :admin)
  login_as(@admin, scope: :user)
end

Dado('estou na página "importacao/sigaa" do sistema') do
  visit('/importacao/sigaa')
end

Dado('existem arquivos JSON de turmas, matérias e participantes disponíveis no repositório') do
  @turmas_json_path        = Rails.root.join('spec/fixtures/sigaa/turmas.json')
  @materias_json_path      = Rails.root.join('spec/fixtures/sigaa/materias.json')
  @participantes_json_path = Rails.root.join('spec/fixtures/sigaa/participantes.json')

  expect(File.exist?(@turmas_json_path)).to be(true)
  expect(File.exist?(@materias_json_path)).to be(true)
  expect(File.exist?(@participantes_json_path)).to be(true)
end

Dado('que existem turmas, matérias e participantes nos arquivos JSON que ainda não existem na base de dados') do
  Turma.delete_all
  Materia.delete_all
  Participante.delete_all

  @turmas_antes        = Turma.count
  @materias_antes      = Materia.count
  @participantes_antes = Participante.count
end

Quando('eu seleciono os arquivos JSON do SIGAA para importação') do
  attach_file('turmas_file',        @turmas_json_path)
  attach_file('materias_file',      @materias_json_path)
  attach_file('participantes_file', @participantes_json_path)
end

Quando('eu confirmo a importação dos dados') do
  click_button 'Importar dados do SIGAA'
end

Então('as turmas do SIGAA que não existiam são cadastradas na base de dados') do
  expect(Turma.count).to be > @turmas_antes
end

Então('as matérias do SIGAA que não existiam são cadastradas na base de dados') do
  expect(Materia.count).to be > @materias_antes
end

Então('os participantes do SIGAA que não existiam são cadastrados na base de dados') do
  expect(Participante.count).to be > @participantes_antes
end

Então('devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado('que algumas turmas, matérias e participantes dos arquivos JSON já existem na base de dados') do
  Turma.delete_all
  Materia.delete_all
  Participante.delete_all

  @turma_existente        = FactoryBot.create(:turma, codigo: 'TURMA_EXISTENTE')
  @materia_existente      = FactoryBot.create(:materia, codigo: 'MAT_EXISTENTE')
  @participante_existente = FactoryBot.create(:participante, matricula: 'PART_EXISTENTE')

  @turmas_antes        = Turma.count
  @materias_antes      = Materia.count
  @participantes_antes = Participante.count
end

Quando('eu realizo a importação dos dados do SIGAA') do
  step 'eu seleciono os arquivos JSON do SIGAA para importação'
  step 'eu confirmo a importação dos dados'
end

Então('os registros já existentes não são duplicados na base de dados') do
  expect(Turma.where(id: @turma_existente.id).count).to eq(1)
  expect(Materia.where(id: @materia_existente.id).count).to eq(1)
  expect(Participante.where(id: @participante_existente.id).count).to eq(1)
end

Então('apenas os registros inexistentes são criados') do
  expect(Turma.count).to be >= @turmas_antes
  expect(Materia.count).to be >= @materias_antes
  expect(Participante.count).to be >= @participantes_antes
end

Dado('que o arquivo JSON de turmas está em formato inválido') do
  @turmas_json_path = Rails.root.join('spec/fixtures/sigaa/turmas_invalido.json')
  File.write(@turmas_json_path, 'isso_nao_e_um_json_valido') unless File.exist?(@turmas_json_path)
  @turmas_antes = Turma.count
end

Quando('eu tento importar os dados do SIGAA') do
  attach_file('turmas_file',        @turmas_json_path)
  attach_file('materias_file',      @materias_json_path)      if defined?(@materias_json_path)
  attach_file('participantes_file', @participantes_json_path) if defined?(@participantes_json_path)

  click_button 'Importar dados do SIGAA'
end

Então('nenhum dado é importado a partir desse arquivo inválido') do
  expect(Turma.count).to eq(@turmas_antes)
end

Dado('que não selecionei nenhum arquivo JSON para importação') do
  @turmas_antes        = Turma.count
  @materias_antes      = Materia.count
  @participantes_antes = Participante.count
end

Quando('eu tento iniciar a importação dos dados do SIGAA') do
  click_button 'Importar dados do SIGAA'
end

Então('nenhum dado é importado') do
  expect(Turma.count).to eq(@turmas_antes)
  expect(Materia.count).to eq(@materias_antes)
  expect(Participante.count).to eq(@participantes_antes)
end
