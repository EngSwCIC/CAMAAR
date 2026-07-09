SENHA_ADMIN = "senhaAdmin123".freeze

def fazer_login(user)
  visit login_path
  fill_in "E-mail ou matrícula", with: user.email
  fill_in "Senha", with: SENHA_ADMIN
  click_button "Entrar"
end

Dado("que existem turmas no departamento do administrador") do
  @departamento = Departamento.create!(nome: "Fábrica de Software")
  @outro_departamento = Departamento.create!(nome: "Engenharia Elétrica")

  @turma = Turma.create!(departamento: @departamento, codigo: "FGA0001", nome: "Engenharia de Software")
  Turma.create!(departamento: @outro_departamento, codigo: "ENE0001", nome: "Circuitos Elétricos")

  @admin = User.create!(
    nome: "Administrador Departamento",
    email: "admin_departamento@camaar.com",
    matricula: "300000001",
    perfil: "Administrador",
    password: SENHA_ADMIN,
    password_confirmation: SENHA_ADMIN,
    primeiro_acesso: false
  )
  Admin.create!(user: @admin, departamento: @departamento)

  fazer_login(@admin)
end

Quando("o administrador selecionar uma dessas turmas") do
  visit turmas_path
  click_link "#{@turma.codigo} - #{@turma.nome}"
end

Então("o sistema deve exibir os dados correspondentes") do
  expect(page).to have_content(@turma.codigo)
  expect(page).to have_content(@turma.nome)
  expect(page).to have_content(@departamento.nome)
end

Dado("que não existem turmas no departamento ou turma não pertence ao departamento") do
  @departamento = Departamento.create!(nome: "Ciência da Computação")

  @admin = User.create!(
    nome: "Administrador Sem Turmas",
    email: "admin_sem_turmas@camaar.com",
    matricula: "300000002",
    perfil: "Administrador",
    password: SENHA_ADMIN,
    password_confirmation: SENHA_ADMIN,
    primeiro_acesso: false
  )
  Admin.create!(user: @admin, departamento: @departamento)

  fazer_login(@admin)
end

Quando("o administrador realizar a consulta") do
  visit turmas_path
end

Então("o sistema deve informar que não há dados disponíveis") do
  expect(page).to have_content("Não há dados disponíveis")
end
