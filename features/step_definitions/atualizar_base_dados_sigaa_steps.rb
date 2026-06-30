require 'tempfile'
require 'json'

# Dados de fixture reutilizáveis

CLASSES_SIGAA = [
  {
    "code"  => "CIC0001",
    "name"  => "Engenharia de Software",
    "class" => { "classCode" => "TA", "semester" => "2026/1" }
  }
].freeze

def membros_sigaa(nome:, email:, matricula: "000001")
  [{
    "code"      => "CIC0001",
    "classCode" => "TA",
    "semester"  => "2026/1",
    "docente"   => {
      "nome"         => nome,
      "email"        => email,
      "usuario"      => matricula,
      "departamento" => "CIC"
    },
    "dicente" => []
  }]
end

def json_upload(data)
  tmp = Tempfile.new(["sigaa", ".json"])
  tmp.write(data.to_json)
  tmp.flush
  Rack::Test::UploadedFile.new(tmp.path, "application/json")
end

# Posta nos importar_dados_path e navega de volta para ver o flash
def importar(classes_upload, members_upload)
  page.driver.post(
    importar_dados_path,
    { classes_file: classes_upload, members_file: members_upload }
  )
  visit gerenciamento_path
end

# Background

Given("que o usuário está autenticado com perfil de administrador") do
  @depto_adm = Departamento.find_or_create_by!(nome_departamento: "CIC")
  @admin_senha = "Admin123"
  @admin_usuario = Usuario.create!(
    nome: "Admin Teste",
    email: "admin@unb.br",
    password: @admin_senha,
    password_confirmation: @admin_senha,
    role: :admin
  )
  Admin.create!(usuario: @admin_usuario, departamento: @depto_adm)

  visit login_path
  fill_in "Email", with: @admin_usuario.email
  fill_in "Senha", with: @admin_senha
  find("input[type=\"submit\"]").click
end

Given("está na página de atualização de dados do SIGAA") do
  visit gerenciamento_path
end

Given("existem registros previamente cadastrados no banco de dados") do
  @depto_adm ||= Departamento.find_or_create_by!(nome_departamento: "CIC")
  @materia_existente = Materia.create!(
    codigoMateria: "CIC0001",
    nome_materia: "Engenharia de Software",
    departamento: @depto_adm
  )
  @prof_existente = Usuario.create!(
    nome: "Prof Existente",
    email: "prof@unb.br",
    password: "Senha123",
    password_confirmation: "Senha123",
    role: :professor
  )
  @professor_existente = Professor.create!(usuario: @prof_existente)
  Turma.create!(
    materia: @materia_existente,
    professor: @professor_existente,
    numero_turma: 1,
    semestre_string: "2026/1"
  )
end

#  Scenario 4 (sem privilégios)

Given("que o usuário autenticado possui perfil sem privilégio de administrador") do
  @prof_sem_priv = Usuario.create!(
    nome: "Professor Sem Privilégio",
    email: "prof.sempriv@unb.br",
    password: "Senha123",
    password_confirmation: "Senha123",
    role: :professor
  )
  visit login_path
  fill_in "Email", with: @prof_sem_priv.email
  fill_in "Senha", with: "Senha123"
  find("input[type=\"submit\"]").click
end

# Passos "seleciona arquivo" — preparam instâncias para o upload


When("ele seleciona um arquivo válido exportado do SIGAA contendo dados atualizados") do
  @classes_up = json_upload(CLASSES_SIGAA)
  @members_up = json_upload(membros_sigaa(nome: "Prof Atualizado", email: "prof@unb.br"))
end

When("ele seleciona um arquivo válido cujos dados são identicos aos já cadastrados") do
  @classes_up = json_upload(CLASSES_SIGAA)
  @members_up = json_upload(membros_sigaa(nome: "Prof Existente", email: "prof@unb.br"))
end

When("ele seleciona um arquivo inválido contendo registros que ainda não existem no banco") do
  @classes_up = json_upload(CLASSES_SIGAA)
  @members_up = json_upload(membros_sigaa(nome: "Prof Novo", email: "prof.novo@unb.br", matricula: "999999"))
end

When("ele seleciona um arquivo cujo conteúdo não segue o padrão esperado do SIGAA") do
  @classes_up = json_upload(CLASSES_SIGAA)
  tmp = Tempfile.new(["sigaa_invalido", ".json"])
  tmp.write("este_nao_e_um_json: { {{ inválido")
  tmp.flush
  @members_up = Rack::Test::UploadedFile.new(tmp.path, "application/json")
end

# Passos "clica em atualizar"

When("clica em \"atualizar\"") do
  importar(@classes_up, @members_up)
end

When("ele clica em \"atualizar\" sem selecionar nenhum arquivo") do
  page.driver.post(importar_dados_path, {})
  visit gerenciamento_path
end

# Tentativa de acesso sem privilégio — Scenario 4

When("ele tenta acessar a página de atualização de dados do SIGAA") do
  dummy = json_upload(CLASSES_SIGAA)
  page.driver.post(importar_dados_path, { classes_file: dummy, members_file: dummy })
end

# Then — Scenario 1: Atualização realizada com sucesso

Then("o sistema deve identificar os registros já existentes") do
  expect(page).to have_css(".flash-notice")
end

Then("deve atualizar os campos modificados de cada registro") do
  expect(Usuario.find_by(email: "prof@unb.br")&.nome).to eq("Prof Atualizado")
end

Then("deve exibir um resumo informando quantos registros foram atualizados") do
  expect(page).to have_content("atualizados")
end

# Then — Scenario 2: Sem alterações nos dados

Then("o sistema não deve modificar nenhum registro") do
  expect(Usuario.find_by(email: "prof@unb.br")&.nome).to eq("Prof Existente")
end

Then("deve exibir uma mensagem informando que nnehuma alteração foi necessária") do
  expect(page).to have_content("Nenhuma alteração")
end


# Then — Scenario 3: Dados faltantes no arquivo (registros novos)

Then("deve sinalizar os registros novos encontrados") do
  expect(page).to have_css(".flash-notice")
  expect(page).to have_content("criados")
end

Then("deve informar ao administrador que os arquivos estão com dados faltantes") do
  expect(page).to have_content(/criados|atualizados|Nenhuma alteração/)
end

# Then — Scenario 4: Usuário sem privilégios

Then("o sistema não deve permitir o acesso") do
  denied = (begin; page.status_code == 403; rescue; false; end) ||
           page.has_text?(/permiss|negado|administrador/i)
  expect(denied).to be_truthy
end

Then("deve exibir uma mensagem informando que a operação requer privilégios de administrador") do
  expect(page).to have_content("privilégios de administrador")
end

# Then — Scenario 5: Arquivo de estrutura inválida

Then("deve exibir uma mensagem de erro informando que a estrutura do arquivo é inválida") do
  expect(page).to have_content(/JSON inválido|inválido/i)
end

# Then — Scenario 6: Sem arquivo selecionado

Then("o sistema não deve realizar a atualização") do
  expect(page).to have_css(".flash-alert")
end

Then("deve exibir uma mensagem de erro indicando que é necessário selecionar um arquivo") do
  expect(page).to have_content("Selecione os dois arquivos JSON para importar.")
end
