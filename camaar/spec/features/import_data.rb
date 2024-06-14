require 'rails_helper'

feature 'Import Data from json' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin sends email to students to register' do
    departament = create(:department,:departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator)
    user = create(:user, :user5)
    teacher = create(:teacher)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'

    click_link 'Importar Dados'

    expect(page).to have_content 'Opções para Importação'

    select 'Turmas', from: 'select_data'

    json = Rails.root + 'db/classes.json'

    page.attach_file(json) do
      page.find('file-upload-button').click
    end

    click_button 'Importar'

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

  scenario 'admin can import classes' do
    departament = create(:department,:departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator)
    user = create(:user, :user5)
    teacher = create(:teacher)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'

    click_link 'Importar Dados'

    expect(page).to have_content 'Opções para Importação'

    select 'Turmas', from: 'select_data'

    json = Rails.root + 'db/classes.json'

    page.attach_file(json) do
      page.find('file-upload-button').click
    end

    click_button 'Importar'

    expect(page).to have_content 'Turmas'
    click_link 'Turmas'

    expect(page).to have_content 'DEPTO CIÊNCIAS DA COMPUTAÇÃO'
    expect(page).to have_content 'BANCOS DE DADOS'
  end

  scenario 'admin can regiser departments different than their department' do
    department = create(:department, :root)
    admin = create(:admin, :admin1)
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

    expect(page).to have_content 'Importar'

    click_button 'Importar'

    expect(page).to have_content 'Turmas'
    expect(page).to have_content 'Opções para Importação'

    department = Department.find_by(id: 508)
    expect(department.id).to eq(508)
    expect(department.initials).to eq('CIC')
    expect(department.name).to eq('DEPTO CIÊNCIAS DA COMPUTAÇÃO')
  end
end

# token = user.send_reset_password_instructions
# put :update, params: { 'user' => {
#   'reset_password_token' => token,
#   'password' => '1234567', 'password_confirmation' => '1234567'
# } }
# put_update_with_params
