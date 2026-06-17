Dado('que estou na página de gerenciamento') do
  departamento = Departamento.first || Departamento.create!(nome: "Ciência da Computação", codigo: "CIC")
  @admin = Administrador.first || Administrador.create!(
    nome: "Admin Teste",
    matricula: "admin",
    email: "admin@teste.com",
    senha: "Senha123",
    departamento: departamento
  )

  allow_any_instance_of(AdminController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, Administrador.find(controller.params[:admin_id]))
  end

  allow_any_instance_of(TemplatesController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, Administrador.find(controller.params[:admin_id]))
  end

  visit admin_gerenciamento_path(@admin)
end

Dado('que eu importei os dados do SIGAA com sucesso') do
  # implementar a partir da feature de importar dados
end

Então('um email de definição de senha é enviado para o email {string}') do |email|
  usuario = Usuario.find_by!(email: email)
  ActionMailer::Base.deliveries.clear
  usuario.enviar_email_definicao_senha!

  @email_destino = email

  enviados = ActionMailer::Base.deliveries.select { |m| m.to == [ email ] }
  expect(enviados).not_to be_empty
end
