# encoding: utf-8

# ==================== CONTEXTO ====================

Dado('que recebi um e-mail de solicitação de troca de senha no endereço {string}') do |email|
  @user = User.create!(
    email:                 email,
    matricula:             '190084006',
    role:                  'discente',
    password:              'placeholder_temp',
    password_confirmation: 'placeholder_temp'
  )
  @user.generate_reset_token!
end

Dado('cliquei no link de redefinição de senha contido no e-mail') do
  visit password_reset_path(@user.reset_token)
end

# ==================== CONTEXTO EXTRA (cenário do link expirado) ====================

Dado('que o link de redefinição de senha foi enviado há mais de 24 horas') do
  @user.update_columns(reset_sent_at: 25.hours.ago)
end

# ==================== VERIFICAÇÕES ====================

Então('permaneço na página de redefinição de senha') do
  expect(page).to have_current_path(password_reset_path(@user.reset_token), wait: 5)
end