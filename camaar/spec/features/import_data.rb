require 'rails_helper'

feature 'Import Data from json' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'admin sends email to students to register' do
    admin = create(:admin)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'

    visit '/admins/import'

    json = Rails.root + 'db/class_members.json'

    #bundle exec rspec spec/features/import_data_spec.rb

    page.attach_file(json) do
        page.find('file-upload-button').click
    end

    click_button 'Importar'

    email = 'mholanda@unb.br'

    open_email(email).click_link 'Registrar'

  end
end

# token = user.send_reset_password_instructions
# put :update, params: { 'user' => {
#   'reset_password_token' => token,
#   'password' => '1234567', 'password_confirmation' => '1234567'
# } }
# put_update_with_params
