SENHA_SHARED_PT = "Senha123admin"

def criar_e_logar_admin(email: "admin.pt@escola.com")
  departamento = Departamento.find_or_create_by!(nome_departamento: "Depto Teste PT")
  usuario = Usuario.find_by(email: email)
  unless usuario
    usuario = Usuario.create!(
      nome: "Admin PT",
      email: email,
      password: SENHA_SHARED_PT,
      password_confirmation: SENHA_SHARED_PT,
      role: :admin
    )
  end
  Admin.find_or_create_by!(usuario: usuario, departamento: departamento)
  CriadorFormulario.find_or_create_by!(usuario: usuario)

  visit login_path
  fill_in "Email", with: usuario.email
  fill_in "Senha", with: SENHA_SHARED_PT
  find("input[type='submit']").click
  usuario
end

def criar_e_logar_estudante(email: "estudante.pt@escola.com")
  usuario = Usuario.find_by(email: email)
  unless usuario
    usuario = Usuario.create!(
      nome: "Estudante PT",
      email: email,
      password: SENHA_SHARED_PT,
      password_confirmation: SENHA_SHARED_PT,
      role: :estudante
    )
    Estudante.create!(usuario: usuario)
  end

  visit login_path
  fill_in "Email", with: usuario.email
  fill_in "Senha", with: SENHA_SHARED_PT
  find("input[type='submit']").click
  usuario
end

def criar_e_logar_professor(email: "professor.pt@escola.com")
  usuario = Usuario.find_by(email: email)
  unless usuario
    usuario = Usuario.create!(
      nome: "Professor PT",
      email: email,
      password: SENHA_SHARED_PT,
      password_confirmation: SENHA_SHARED_PT,
      role: :professor
    )
    Professor.create!(usuario: usuario)
  end

  visit login_path
  fill_in "Email", with: usuario.email
  fill_in "Senha", with: SENHA_SHARED_PT
  find("input[type='submit']").click
  usuario
end

# Shared Given steps for # language: pt features

Given("que estou logado como administrador") do
  @current_usuario = criar_e_logar_admin
end

Given("que estou logado como estudante") do
  @current_usuario = criar_e_logar_estudante
end

Given("que estou logado como coordenador de departamento") do
  @current_usuario = criar_e_logar_admin(email: "coordenador.pt@escola.com")
end

Given("que estou logado como um usuário sem perfil de administrador") do
  @current_usuario = criar_e_logar_estudante(email: "semadmin.pt@escola.com")
end

Then("o sistema nega o acesso") do
  expect(current_path).not_to eq(login_path)
  expect(page).to have_text(/permiss|não pertence|restrito|negado/i)
end

Then("vejo uma mensagem informando que não tenho permissão para acessar esta funcionalidade") do
  expect(page).to have_text(/permiss|restrito|negado/i)
end
