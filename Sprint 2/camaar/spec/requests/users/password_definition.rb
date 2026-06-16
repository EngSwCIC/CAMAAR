require 'rails_helper'

RSpec.describe 'Definição de Senha', type: :system do

  let(:email) { 'user@unb.br' }


  let!(:user) do
    User.create!(
      name:         'Usuário Teste',
      email:        email,
      matricula:    '190000001',
      role:         'user',
      password:     SecureRandom.hex(16),
      first_access: true
    )
  end

  let(:reset_token) do
    user.send_reset_password_instructions
    user.instance_variable_get(:@raw_reset_password_token)
  end

  before do
    reset_token
    visit edit_user_password_path(reset_password_token: reset_token)
  end

  # ─── Happy path ──────────────────────────────────────────────────────────

  context 'quando as senhas coincidem' do

    before do
      fill_in 'Senha',           with: 'StrongPass123'
      fill_in 'Confirmar Senha', with: 'StrongPass123'
      click_button 'Salvar Senha'
    end

    it 'exibe mensagem de sucesso' do
      expect(page).to have_content('Senha definida com sucesso')
    end

    it 'redireciona para a página de login' do
      expect(page).to have_current_path(new_user_session_path)
    end

    it 'marca first_access como false' do
      expect(user.reload.first_access).to be false
    end

    it 'permite login com a nova senha' do
      fill_in 'Login',  with: email
      fill_in 'Senha',  with: 'StrongPass123'
      click_button 'Entrar'

      expect(page).not_to have_content('E-mail ou senha inválidos')
    end

  end

  # ─── Sad path: confirmação divergente ─────────────────────────────────────

  context 'quando a confirmação de senha é diferente' do

    before do
      fill_in 'Senha',           with: 'StrongPass123'
      fill_in 'Confirmar Senha', with: 'WrongPass456'
      click_button 'Salvar Senha'
    end

    it 'permanece na página de definição de senha' do
      expect(page).to have_current_path(user_password_path, ignore_query: true)
    end

    it 'exibe mensagem de erro' do
      expect(page).to have_content('As senhas não coincidem')
    end

    it 'não altera o first_access do usuário' do
      expect(user.reload.first_access).to be true
    end

  end

  # ─── Sad path: token inválido ──────────────────────────────────────────────

  context 'quando o token de reset é inválido' do

    before do
      visit edit_user_password_path(reset_password_token: 'token_invalido')
    end

    it 'redireciona para a página de login' do
      fill_in 'Senha',           with: 'StrongPass123'
      fill_in 'Confirmar Senha', with: 'StrongPass123'
      click_button 'Salvar Senha'

      expect(page).to have_content('Token de redefinição de senha inválido')
    end

  end

  # ─── Sad path: token expirado ─────────────────────────────────────────────

  context 'quando o token de reset está expirado' do

    before do
      user.update_column(
        :reset_password_sent_at,
        Devise.reset_password_within.ago - 1.minute
      )
    end

    it 'informa que o token expirou' do
      fill_in 'Senha',           with: 'StrongPass123'
      fill_in 'Confirmar Senha', with: 'StrongPass123'
      click_button 'Salvar Senha'

      expect(page).to have_content('expirou')
    end

  end

end