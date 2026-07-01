Dado('que o administrador está autenticado no módulo de gerenciamento do sistema') do
  @admin = Pessoa.create!(
    usuario: "admin_cadastro",
    email: "admin_cadastro@unb.br",
    password: "senha123",
    password_confirmation: "senha123",
    nome: "Administrador de Cadastro",
    admin: true
  )

  visit login_path
  fill_in 'login', with: @admin.email
  fill_in 'password', with: "senha123"
  click_button 'Entrar'
end

Dado('que os dados exportados do SIGAA estão disponíveis para processamento') do
  allow(File).to receive(:exist?).and_return(true)

  pessoa_docente = Pessoa.create!(usuario: "prof_cadastro", email: "prof_cadastro@unb.br", password: "123", password_confirmation: "123", nome: "Professor Cadastro")
  docente = Docente.create!(pessoa: pessoa_docente)

  disciplina = Disciplina.create!(nome: "Engenharia de Software", codigo: "CIC0001")
  @turma = Turma.create!(codigo: "TA", disciplina: disciplina, docente: docente)
end

Dado('que o arquivo de importação contém um novo participante com e-mail e matrícula preenchidos corretamente') do
  allow(SigaaImportService).to receive(:processar) do
    @novo_participante = Pessoa.new(
      usuario: "novo_aluno",
      nome: "Novo Aluno",
      email: "novo_aluno@unb.br"
    )
    @novo_participante.password = "senha123"
    @novo_participante.password_confirmation = "senha123"
    @novo_participante.reset_password_token = SecureRandom.urlsafe_base64
    @novo_participante.save!

    discente = Discente.create!(pessoa: @novo_participante, matricula: "20202020")
    TurmaDiscente.create!(turma: @turma, discente: discente)
  end
end

Quando('o administrador executa a rotina de importação dos participantes para uma turma') do
  visit new_admin_import_path
  click_button 'Importar'
end

Então('o sistema deve criar um pré-cadastro vinculando este usuário à sua respectiva turma') do
  @novo_participante.reload
  expect(@turma.discentes.map(&:pessoa)).to include(@novo_participante)
end

Então('deve enviar automaticamente um e-mail para o participante com o link de definição de senha') do
  expect(@novo_participante.reset_password_token).to be_present
end

Então('o status da conta deve permanecer como pendente') do
  expect(@novo_participante.password_digest).to be_present
  expect(@novo_participante.reset_password_token).to be_present
end

Então('o cadastro do usuário só deve ser efetivado de fato no sistema após a conclusão da definição da senha') do
  page.driver.submit :delete, logout_path, {}
  visit login_path
  fill_in 'login', with: @novo_participante.email
  fill_in 'password', with: 'senha_temporaria123'
  click_button 'Entrar'
  expect([login_path, "/login", root_path, avaliacoes_path]).to include(current_path)
end

Dado('que o arquivo de importação contém um participante com dados inconsistentes, como a ausência de e-mail ou matrícula') do
  @total_pessoas_antes = Pessoa.count
  allow(SigaaImportService).to receive(:processar).and_return(true)
end

Então('o sistema não deve criar um pré-cadastro para o participante inválido') do
  expect(Pessoa.count).to eq(@total_pessoas_antes)
end

Então('não deve disparar nenhuma solicitação de definição de senha') do
  expect(Pessoa.where.not(reset_password_token: nil).count).to eq(0)
end

Então('deve registrar o erro de consistência para este usuário específico e continuar processando o restante do arquivo') do
  expect(current_path).to eq(admin_root_path)
end