Dado('que estou logado como administrador') do
  @admin = User.find_or_create_by!(matricula: 'admin') do |u|
    u.email = 'admin@admin.com'
    u.role = 'admin'
    u.password = 'password123'
    u.password_confirmation = 'password123'
  end

  visit login_path
  fill_in 'Email ou Matrícula', with: 'admin'
  fill_in 'Senha', with: 'password123'
  click_button 'Entrar'
  expect(page).not_to have_current_path(login_path, wait: 5)
end

Dado('que estou logado como Administrador') do
  step "que estou logado como administrador"
end

Dado('que estou logado como Participante') do
  @user = User.find_or_create_by!(matricula: '190084006') do |u|
    u.email = 'user@user.com'
    u.role = 'discente'
    u.password = 'password123'
    u.password_confirmation = 'password123'
  end

  visit login_path
  fill_in 'Email ou Matrícula', with: '190084006'
  fill_in 'Senha', with: 'password123'
  click_button 'Entrar'
  expect(page).not_to have_current_path(login_path, wait: 5)
end