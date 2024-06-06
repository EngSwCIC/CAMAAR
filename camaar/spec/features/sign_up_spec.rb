require 'rails_helper'

feature 'Register User' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin registering user' do
    #admin = create(:admin)

    email = 'test@gmail.com'
    password = 'abc123'

    UsersMailer.register_user(email).deliver_now
    open_email(email).click_link 'Registrar'
    expect(page).to have_content 'Olá, Usuário!'
    expect(page).to have_content 'Defina sua senha'
    fill_in 'password', with: password
    fill_in 'password2', with: password
    click_button 'Confirmar'
    open_email(email).click_link 'Confirmar'
    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Confirmar'
    expect(page).to have_content 'Usuário'
    expect(page).to have_content 'Formulário de Avaliação'
  end
end
