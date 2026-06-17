# encoding: utf-8

Dado('que estou logado como Administrador de teste') do
  @user = User.find_by(email: 'admin@teste.com')
  unless @user
    @user = User.create!(
      email: 'admin@teste.com',
      matricula: 'admin123',
      password: 'password123',
      password_confirmation: 'password123',
      role: 'admin'
    )
  end
  visit login_path
  fill_in 'Email ou Matrícula', with: 'admin@teste.com'
  fill_in 'Senha', with: 'password123'
  click_button 'Entrar'
end

Dado('que importei o arquivo {string}') do |arquivo|
  d = Disciplina.find_or_create_by!(code: 'CIC0097', name: 'BANCOS DE DADOS')
  Turma.find_or_create_by!(classCode: 'TA', semester: '2021.2', disciplina: d)
  
  visit admin_imports_path
  attach_file('file', File.join(Rails.root, arquivo))
  select 'Participantes', from: 'import_type'
  click_button 'Confirmar Importação'
end

Dado('o sistema identificou the novo usuário with matrícula {string}') do |matricula|
  @imported_user = User.find_by(matricula: matricula)
  expect(@imported_user).not_to be_nil
end

Quando('o usuário {string} acessa a página de login') do |matricula|
  click_button 'Logout'
  visit login_path
end

Quando('preencho o campo de cadastro {string} com {string}') do |campo, valor|
  fill_in campo, with: valor
end

Quando('deixo o campo de cadastro {string} em branco') do |campo|
  fill_in campo, with: ''
end

Quando('clico no botão de cadastro {string}') do |botao|
  click_button botao
end

Então('sou redirecionado para a página de cadastro {string}') do |pagina|
  case pagina
  when 'Definição de Senha'
    user = User.find_by(matricula: @current_matricula || '190084006')
    expect(page.current_path).to include("/definir-senha/")
  when 'painel principal'
    if @user&.discente? || @user&.docente?
      expect(page).to have_current_path(formularios_path)
    else
      expect(page).to have_current_path(home_path)
    end
  end
end

Dado('que o usuário {string} está na página {string}') do |matricula, pagina|
  @user = User.find_by(matricula: matricula)
  if @user.nil?
     @user = User.create!(matricula: matricula, email: "test_#{matricula}@example.com", role: 'discente')
  end
  @user.generate_invitation_token! if @user.invitation_token.nil?
  visit password_set_path(@user.invitation_token)
end

Então('meu status no sistema passa a ser {string}') do |status|
  @user.reload
  expect(@user.password_digest).not_to be_nil
end

Então('permaneço na página de cadastro {string}') do |pagina|
  expect(page).to have_content('DEFINIR SENHA')
end

Dado('que o usuário {string} foi importado mas não definiu senha') do |matricula|
  @user = User.find_or_create_by!(matricula: matricula) do |u|
    u.email = "test_#{matricula}@example.com"
    u.role = 'discente'
    u.generate_invitation_token!
  end
  @current_matricula = matricula
  # login and redirection happens in the 'Quando' step
end

Quando('tento acessar a página {string} diretamente') do |pagina|
  visit login_path
  fill_in 'Email ou Matrícula', with: @current_matricula
  click_button 'Entrar'
end

Então('vejo o alerta de cadastro {string}') do |alerta|
  expect(page).to have_content(alerta)
end

Então('vejo a mensagem de sucesso de cadastro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo a mensagem de erro de cadastro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('vejo a mensagem de cadastro {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
