Dado('que o administrador está autenticado no sistema') do
  @admin = Pessoa.create!(
    email: "admin_sigaa@unb.br",
    password: "senha",
    password_confirmation: "senha",
    admin: true,
    usuario: "admin_sigaa"
  )
  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: "senha"
  click_button 'Entrar'
end

Dado('que o administrador possui permissão para importar dados do SIGAA via arquivos JSON') do
  expect(@admin.admin?).to be_truthy
end

#-----HAPPY PATH ---

Dado('que os arquivos selecionados são {string} e {string} e possuem dados válidos') do |arquivo1, arquivo2|
  allow(File).to receive(:exist?).and_return(true)
  allow(SigaaImportService).to receive(:processar).and_return(true)

  disciplina = Disciplina.create!(nome: "BANCOS DE DADOS", codigo: "CIC0097")

  pessoa_docente = Pessoa.create!(usuario: "maristela_sigaa", password: "123", password_confirmation: "123", nome: "MARISTELA TERTO DE HOLANDA")
  docente = Docente.create!(pessoa: pessoa_docente)

  turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)

  pessoa_aluno1 = Pessoa.create!(usuario: "ana_sigaa", password: "123", password_confirmation: "123", nome: "Ana Clara Jordao Perna")
  Discente.create!(pessoa: pessoa_aluno1)

  pessoa_aluno2 = Pessoa.create!(usuario: "andre_sigaa", password: "123", password_confirmation: "123", nome: "Andre Carvalho de Roure")
  Discente.create!(pessoa: pessoa_aluno2)
end

Quando('o administrador inicia o carregamento dos arquivos no sistema') do
  visit new_admin_import_path
end

Quando('confirma a operação de importação') do
  click_button 'Importar'
end

Então('o sistema deve salvar a matéria inédita {string}, de código {string} \(turma {string}) no banco de dados') do |materia, codigo, turma|
  expect(Disciplina.find_by(codigo: codigo, nome: materia)).to be_present
end

Então('deve registrar e vincular a docente {string} à respectiva turma') do |nome_docente|
  pessoa = Pessoa.find_by(nome: nome_docente)
  expect(Docente.find_by(pessoa: pessoa)).to be_present
end

Então('deve registrar os discentes da lista, como {string} e {string}, vinculando-os à turma {string}') do |aluno1, aluno2, codigo_turma|
  pessoa1 = Pessoa.find_by(nome: aluno1)
  pessoa2 = Pessoa.find_by(nome: aluno2)
  expect(Discente.find_by(pessoa: pessoa1)).to be_present
  expect(Discente.find_by(pessoa: pessoa2)).to be_present
end

Então('deve exibir a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

#-----SAD PATH ---

Dado('que o administrador selecionou um arquivo corrompido ou que não segue a estrutura JSON esperada para turmas e participantes') do
  allow(File).to receive(:exist?).and_return(true)
  allow(SigaaImportService).to receive(:processar).and_raise(StandardError.new("Arquivo inválido"))

  Disciplina.destroy_all
  Docente.destroy_all
  Discente.destroy_all
end

Quando('o administrador tenta realizar a importação do arquivo') do
  visit new_admin_import_path
  click_button 'Importar'
end

Então('o sistema deve bloquear o processamento do arquivo imediatamente') do
  expect([new_admin_import_path, admin_imports_path]).to include(current_path)
end

Então('não deve realizar nenhuma inclusão de matérias, docentes ou discentes no banco de dados') do
  expect(Disciplina.count).to eq(0)
  expect(Docente.count).to eq(0)
  expect(Discente.count).to eq(0)
end

Então('deve exibir uma mensagem alertando que o arquivo enviado é inválido ou incompatível') do
  expect(page).to have_content("Erro ao processar os arquivos JSON")
end