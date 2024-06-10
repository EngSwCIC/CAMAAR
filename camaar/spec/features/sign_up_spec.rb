require 'rails_helper'

feature 'Register User' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin registering user' do
    email = 'chacon@unb.br'
    password = 'abc123'

    department = create(:department)
    admin = create(:admin)

    UsersMailer.register_user(email).deliver_now
    open_email(email).click_link 'Registrar'
    expect(page).to have_content 'Olá, Usuário!'
    expect(page).to have_content 'Defina sua senha'
    fill_in 'password', with: password
    fill_in 'password2', with: password
    click_button 'Confirmar'
    open_email(email).click_link 'Confirmar'
    teachers_id = User.find_by(email: 'chacon@unb.br').id
    puts teachers_id
    teacher = create(:teacher, id: teachers_id)
    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_button 'Confirmar'
    expect(page).to have_content 'Usuário'
    expect(page).to have_content 'Formulário de Avaliação'
  end
end
