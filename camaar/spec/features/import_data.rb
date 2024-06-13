require 'rails_helper'

feature 'Import Data from json' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin sends email to students to register' do
    departament = create(:department)
    admin = create(:admin)
    coordinator = create(:coordinator)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'

    click_link 'Importar Dados'

    expect(page).to have_content 'Opções para Importação'

    select 'Membros', from: 'select_data'

    json = Rails.root + 'db/class_members.json'

    page.attach_file(json) do
      page.find('file-upload-button').click
    end

    click_button 'Importar'

    email = 'mholanda@unb.br'

    open_email(email).click_link 'Registrar'
  end

  scenario 'admin can regiser departments different than their department' do
    # departament = create(:department)
    department = create(:department, id: 1)
    admin = create(:admin)
    coordinator = create(:coordinator, department_id: 1)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'

    click_link 'Importar Dados'

    expect(page).to have_content 'Opções para Importação'

    select 'Departamentos', from: 'select_data'

    json = Rails.root + 'db/departments.json'

    page.attach_file(json) do
      page.find('file-upload-button').click
    end

    click_button 'Importar'
    find('a[name="Turmas"]').click

    expect(page).to have_content 'DEPTO CIÊNCIAS DA COMPUTAÇÃO'
    expect(page).to have_content 'BANCOS DE DADOS'
  end
end

# token = user.send_reset_password_instructions
# put :update, params: { 'user' => {
#   'reset_password_token' => token,
#   'password' => '1234567', 'password_confirmation' => '1234567'
# } }
# put_update_with_params
