Dado('que estou na página de gerenciamento') do
  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação", codigo: "CIC")
  @admin = Administrador.first || Administrador.create!(
    nome: "Admin Teste",
    matricula: "admin",
    email: "admin@teste.com",
    senha: "Senha123",
    departamento: departamento
  )

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

  allow_any_instance_of(AdminController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, Administrador.find(controller.params[:admin_id]))
  end

  allow_any_instance_of(TemplatesController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, Administrador.find(controller.params[:admin_id]))
  end

  visit admin_gerenciamento_path(@admin)
end

Dado('que eu importei os dados do SIGAA com sucesso') do
  dep = Departamento.find_or_create_by!(codigo: "NAO_ESP") { |d| d.nome = "Não especificado" }
  curso = Curso.find_or_create_by!(codigo: "TST") do |c|
    c.nome = "Curso Teste"
    c.departamento = dep
  end
  Discente.find_or_create_by!(matricula: "USR001") do |u|
    u.nome = "Usuário Teste"
    u.email = "usuario@teste.com"
    u.curso = curso
  end
end

Então('o e-mail de usuário {string} está cadastrado no sistema com senha indefinida') do |email|
  usuario = Usuario.find_by(email: email)
  expect(usuario).to be_present,
    "Esperava encontrar um usuário com email '#{email}', mas não encontrei."
  expect(usuario.senha_hash).to be_blank,
    "Esperava que o usuário '#{email}' não tivesse senha definida, mas tinha."
end

Então('um email de definição de senha é enviado para o email {string}') do |email|
  usuario = Usuario.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  usuario.enviar_email_definicao_senha!

  @email_destino = email

  enviados = ActionMailer::Base.deliveries.select { |m| m.to == [ email ] }
  expect(enviados).not_to be_empty
end
