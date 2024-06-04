require 'rails_helper'

feature 'Register User' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin registering user' do
    # admin = Admin.create!({
    #   email: 'test@gmail.com',
    #   password: 'abc123',
    #   password_confirmation: 'abc123',
    #   confirmed_at: Time.now.utc
    # })

    email = 'test@gmail.com'
    password = 'abc123'

    UsersMailer.register_user(email).deliver_now
    open_email(email).click_link 'Registrar'
    expect(page).to have_content 'Olá, usuário!'
    expect(page).to have_content 'Defina sua senha'
    fill_in 'password', with: password
    fill_in 'password2', with: password
    click_button 'Confirmar'
    open_email(email).click_link 'Confirmar'
    expect(page).to have_content 'Formulários Pendentes'
  end
end
