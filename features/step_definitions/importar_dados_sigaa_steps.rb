require 'tempfile'
require 'json'

CLASSES_IMPORTAR = [
  {
    "code"  => "CIC0099",
    "name"  => "Algoritmos e Programação",
    "class" => { "classCode" => "TA", "semester" => "2026/1" }
  }
].freeze

MEMBROS_IMPORTAR = [{
  "code"      => "CIC0099",
  "classCode" => "TA",
  "semester"  => "2026/1",
  "docente"   => {
    "nome"         => "Novo Professor",
    "email"        => "novoprof@unb.br",
    "usuario"      => "123456",
    "departamento" => "CIC"
  },
  "dicente" => []
}].freeze

# "email" faltante faz uma exceção ser levantada Usuario#save! service transaction
MEMBROS_CAMPO_INVALIDO_IMPORTAR = [{
  "code"      => "CIC0099",
  "classCode" => "TA",
  "semester"  => "2026/1",
  "docente"   => {
    "nome"         => "Professor Campo Invalido",
    "usuario"      => "654321",
    "departamento" => "CIC"
  },
  "dicente" => []
}].freeze

JSON_INVALIDO_IMPORTAR = "{ campos: {{ nao_e_json_valido".freeze

# Writes data as-is (String) or serialised (Array/Hash) into a temp file
def upload_conteudo(conteudo)
  tmp = Tempfile.new(["importar", ".json"])
  tmp.write(conteudo.is_a?(String) ? conteudo : conteudo.to_json)
  tmp.flush
  Rack::Test::UploadedFile.new(tmp.path, "application/json")
end

def fazer_import(classes_data, members_data)
  page.driver.post(
    importar_dados_path,
    { classes_file: upload_conteudo(classes_data), members_file: upload_conteudo(members_data) }
  )
  visit gerenciamento_path
end

# Background

Given("Usuário está na página de perfil de Gerenciamento") do
  depto = Departamento.find_or_create_by!(nome_departamento: "CIC")
  senha = "Admin123"
  admin_u = Usuario.create!(
    nome: "Admin Importar",
    email: "admin.importar@unb.br",
    password: senha,
    password_confirmation: senha,
    role: :admin
  )
  Admin.create!(usuario: admin_u, departamento: depto)
  visit login_path
  fill_in "Email", with: admin_u.email
  fill_in "Senha", with: senha
  find("input[type=\"submit\"]").click
  # Admin login redireciona para gerenciamento_path automaticamente
end

# When

When('ele clica em "Importar dados"') do
  # Modal requires JS — with rack-test we verify the button is on the page
  expect(page).to have_content("Importar Dados")
end

# Then — shared across all three scenarios

Then("o sistema deve permitir a importação de arquivo JSON contendo os dados a serem cadastrados") do
  expect(current_path).to eq(gerenciamento_path)
  expect(page).to have_css("dialog.import-dialog", visible: :all)
end

# Then — Scenario 1: Importação com sucesso

Then("deve cadastrar os novos registros no banco de dados") do
  fazer_import(CLASSES_IMPORTAR, MEMBROS_IMPORTAR)
  expect(Usuario.find_by(email: "novoprof@unb.br")).to be_present
end

Then("deve exibir uma mensagem de sucesso com o total de registros importados") do
  expect(page).to have_css(".flash-notice")
  expect(page).to have_content("criados")
end

# Then — Scenario 2: Arquivo em formato inválido

Then("ocorre uma falha na importação") do
  fazer_import(CLASSES_IMPORTAR, JSON_INVALIDO_IMPORTAR)
end

Then("deve exibir uma mensagem de erro relatando formato invalido de arquivo") do
  expect(page).to have_css(".flash-alert")
  expect(page).to have_content("JSON inválido")
end

# Then — Scenario 3: Campos incompatíveis com o banco

Then("algum dos campos recebidos do JSON não condizem com a estrutura do banco de dados") do
  fazer_import(CLASSES_IMPORTAR, MEMBROS_CAMPO_INVALIDO_IMPORTAR)
end

Then("deve exibir uma mensagem de erro relatando falha na importação") do
  expect(page).to have_css(".flash-alert")
  expect(page).to have_content("Erro na importação")
end
