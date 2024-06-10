# spec/system/login_spec.rb
require 'rails_helper'

RSpec.describe 'Sistema de login', type: :system do
  #faz os testes sem abrir o sistema no navegador
  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'Login bem-sucedido' do
    visit login_path

    fill_in 'username', with: 'email@aluno.unb.br'
    fill_in 'password', with: 'password'
    click_button 'Entrar'

    expect(page).to have_content('Welcome, user!')
  end

  it 'Falha no login com credenciais inválidas' do
    visit login_path

    fill_in 'username', with: 'wrong@aluno.unb.br'
    fill_in 'password', with: 'wrongpassword'
    click_button 'Entrar'

    expect(page).to have_content('Invalid username or password')
  end

end
