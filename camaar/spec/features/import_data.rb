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
    departament = create(:department)
    admin = create(:admin)
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

  # Department.create(id:1000,initials:"Root",name:"Root",created_at:Time.now.utc,updated_at:Time.now.utc)
  # Admin.create!(id:100,email:"mandelli@unb.br",password:"abc123",password_confirmation:"abc123",confirmed_at:Time.now.utc)
  # Coordinator.create(id:100,name:"mandelli",admin_id:100,department_id:1000,email:"mandelli@unb.br")

  scenario 'admin can regiser departments different than their department' do
    department = create(:department, id: 1, initials: 'ROOT', name: 'ROOT')
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
