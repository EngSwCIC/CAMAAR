require 'rails_helper'

feature 'Register Admin' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin registering itself' do
    department = create(:department, :departament1)
    admin = build(:admin, :admin1)
    email = admin.email
    password = admin.password

    visit '/admins/register'
    expect(page).to have_content 'Olá, administrador!'
    expect(page).to have_content 'Defina sua senha'
    fill_in 'email', with: email
    fill_in 'password', with: password
    fill_in 'password2', with: password
    click_button 'Confirmar'
    open_email(email).click_link 'Confirmar minha conta'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'

    fill_in 'email', with: email
    fill_in 'password', with: password

    admin_coord = Admin.find_by(email:)
    coordinator = create(:coordinator, :coordinator1, admin_id: admin_coord.id)

    click_button 'Confirmar'
    expect(page).to have_content 'Mandelli'
    expect(page).to have_content 'Coordenador'
    expect(page).to have_content 'Importar Dados'
    expect(page).to have_content 'Não foram encontrados templates'
  end
end
