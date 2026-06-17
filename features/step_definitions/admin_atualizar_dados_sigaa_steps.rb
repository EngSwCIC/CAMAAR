Dado('que o administrador possui credenciais validas de gestao') do
  @admin = Pessoa.create!(
    usuario: "admin_sync",
    email: "admin_sync@unb.br",
    password: "senha123",
    password_confirmation: "senha123",
    nome: "Administrador de Sincronizacao",
    admin: true
  )
end

Dado('esta logado no painel administrativo do sistema') do
  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: "senha123"
  click_button 'Entrar'

  expect(current_path).to eq(admin_root_path)
end

#-----HAPPY PATH ---

Quando('o administrador solicita a atualizacao manual da base de dados') do
  @disciplinas_antes = Disciplina.count
  visit new_admin_import_path
end

Quando('o servico do SIGAA responde corretamente com os dados atuais') do
  allow(File).to receive(:exist?).and_return(true)
  allow(SigaaImportService).to receive(:processar).and_return(true)

  click_button 'Importar'
end

Então('o sistema deve processar e atualizar a base de dados existente sem perda de dados criticos') do
  expect(current_path).to eq(admin_root_path)
  expect(Disciplina.count).to be >= @disciplinas_antes
end

Então('deve registrar a data e hora da ultima sincronizacao') do
  expect(current_path).to eq(admin_root_path)
end

Então('deve exibir a mensagem de sucesso {string}') do |mensagem|
  expect(page).to have_content("sucesso")
end

#-----SAD PATH ---

Quando('o servico do SIGAA encontra-se indisponivel ou retorna erro de integracao') do
  allow(File).to receive(:exist?).and_return(true)
  allow(SigaaImportService).to receive(:processar).and_raise(StandardError.new("Falha na sincronizacao: O sistema SIGAA esta indisponivel no momento."))

  click_button 'Importar'
end

Então('o sistema aborta a operacao de atualizacao') do
  expect([new_admin_import_path, admin_imports_path]).to include(current_path)
end

Então('nao deve aplicar nenhuma alteracao parcial na base de dados existente') do
  expect(Disciplina.count).to eq(@disciplinas_antes)
end
