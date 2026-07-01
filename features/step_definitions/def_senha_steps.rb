# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que recebi um e-mail de solicitação de cadastro no endereço {string}') do |email|
  @user = User.create!(
    email:     email,
    matricula: '190084006',
    role:      'discente',
    password:              'placeholder_temp',
    password_confirmation: 'placeholder_temp'
  )
  @user.generate_invitation_token!
end

Dado('cliquei no link de definição de senha contido no e-mail') do
  visit password_set_path(@user.invitation_token)
end

# ==================== CONTEXTO EXTRA (cenário do link expirado) ====================

Dado('que o link de definição de senha foi enviado há mais de 24 horas') do
  @user.update_columns(invitation_sent_at: 25.hours.ago)
end

# ==================== VERIFICAÇÕES ====================

Então('sou redirecionado para a página de login') do
  expect(page).to have_current_path(login_path, wait: 5)
end

Então('permaneço na página de definição de senha') do
  expect(page).to have_current_path(password_set_path(@user.invitation_token), wait: 5)
end