# frozen_string_literal: true

Dado('eu estou matriculado na turma {string}') do |nome_turma|
  # Pega o usuário que acabou de ser criado e logado pelo passo anterior
  @user = User.last

  # Sincroniza o User com a tabela legada Usuario e cria o Discente
  @usuario = Usuario.find_by(email: @user.email) || Usuario.create!(
    id: @user.id,
    login: "aluno#{@user.id}",
    email: @user.email,
    nome: @user.nome || "Estudante",
    perfil: 0,
    password: "password123"
  )

  @discente = Discente.find_by(usuario_id: @usuario.id) || Discente.create!(
    usuario_id: @usuario.id,
    curso: "Ciência da Computação",
    matricula: @user.matricula || "190014121"
  )

  codigo = nome_turma.split(" - ").first
  nome = nome_turma.split(" - ").last

  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação")
  @turma = Turma.find_or_create_by!(codigo: codigo, nome: nome, semestre: "2021.2", departamento: departamento)

  Matricula.find_or_create_by!(discente: @discente, turma: @turma)
end

Dado('existe um formulário aberto e não respondido para esta turma') do
  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação")

  # Cria um professor dinâmico para não dar conflito de e-mail/matrícula única
  user_doc = User.create!(email: "prof#{rand(1000..9999)}@unb.br", nome: "Prof", matricula: "99#{rand(100..999)}", perfil: "docente", password: "password123")
  usuario_doc = Usuario.create!(id: user_doc.id, login: "prof#{user_doc.id}", email: user_doc.email, nome: user_doc.nome, perfil: 1, password: "password123")

  docente = Docente.find_or_create_by!(usuario_id: usuario_doc.id, departamento: departamento)
  template = Template.first || Template.create!(titulo: "Avaliação Padrão", docente: docente)

  @formulario = Formulario.create!(titulo: "Avaliação de Turma", turma: @turma, template: template, prazo: 1.week.from_now)
end

Quando('eu acesso a aba de {string}') do |aba|
  visit formularios_path
end

Então('eu devo ver o formulário da turma {string} na lista') do |nome_turma|
  # Extrai apenas o código (ex: CIC0097) para evitar erro de inversão de texto na tela
  codigo = nome_turma.split(" - ").first
  expect(page).to have_content(codigo)
end

Dado('o sistema registra que eu não possuo matrícula ativa no semestre atual') do
  @user = User.last
  @usuario = Usuario.find_by(email: @user.email) || Usuario.create!(id: @user.id, login: "aluno#{@user.id}", email: @user.email, nome: @user.nome || "Estudante", perfil: 0, password: "password123")
  @discente = Discente.find_by(usuario_id: @usuario.id) || Discente.create!(usuario_id: @usuario.id, curso: "Ciência da Computação", matricula: @user.matricula || "190014121")

  # Remove as matrículas para testar o cenário de lista vazia
  @discente.matriculas.destroy_all
end

Dado('eu não estou matriculado na turma {string}') do |nome_turma|
  @user = User.last
  @usuario = Usuario.find_by(email: @user.email) || Usuario.create!(id: @user.id, login: "aluno#{@user.id}", email: @user.email, nome: @user.nome || "Estudante", perfil: 0, password: "password123")
  @discente = Discente.find_by(usuario_id: @usuario.id) || Discente.create!(usuario_id: @usuario.id, curso: "Ciência da Computação", matricula: @user.matricula || "190014121")

  codigo = nome_turma.split(" - ").first
  nome = nome_turma.split(" - ").last

  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação")
  @turma_nao_matriculada = Turma.find_or_create_by!(codigo: codigo, nome: nome, semestre: "2021.2", departamento: departamento)
end

Dado('existe um formulário aberto para esta turma') do
  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação")

  user_doc = User.create!(email: "prof#{rand(1000..9999)}@unb.br", nome: "Prof", matricula: "99#{rand(100..999)}", perfil: "docente", password: "password123")
  usuario_doc = Usuario.create!(id: user_doc.id, login: "prof#{user_doc.id}", email: user_doc.email, nome: user_doc.nome, perfil: 1, password: "password123")

  docente = Docente.find_or_create_by!(usuario_id: usuario_doc.id, departamento: departamento)
  template = Template.first || Template.create!(titulo: "Avaliação Padrão", docente: docente)

  Formulario.create!(titulo: "Avaliação de Turma", turma: @turma_nao_matriculada, template: template, prazo: 1.week.from_now)
end

Então('eu não devo ver o formulário da turma {string} na lista') do |nome_turma|
  expect(page).not_to have_content(nome_turma)
end

Dado('eu já respondi ao formulário de avaliação desta turma') do
  @user = User.last
  @usuario = Usuario.find_by(email: @user.email)
  @discente = Discente.find_by(usuario_id: @usuario.id)

  if @formulario.nil?
    departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação")
    user_doc = User.create!(email: "prof#{rand(1000..9999)}@unb.br", nome: "Prof", matricula: "99#{rand(100..999)}", perfil: "docente", password: "password123")
    usuario_doc = Usuario.create!(id: user_doc.id, login: "prof#{user_doc.id}", email: user_doc.email, nome: user_doc.nome, perfil: 1, password: "password123")
    docente = Docente.find_or_create_by!(usuario_id: usuario_doc.id, departamento: departamento)
    template = Template.first || Template.create!(titulo: "Avaliação Padrão", docente: docente)

    @formulario = Formulario.create!(titulo: "Avaliação de Turma", turma: @turma, template: template, prazo: 1.week.from_now)
  end

  EnvioFormulario.create!(formulario: @formulario, discente: @discente)
end

Então('devo ver que não tem formulario pendente.') do
  expect(page).to have_content("Nenhum formulário pendente. Você está em dia!")
end
