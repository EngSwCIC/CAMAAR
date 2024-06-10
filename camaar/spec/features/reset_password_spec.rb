require 'rails_helper'

feature 'Reset Password' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'user forgot_password' do
    department = create(:department)
    admin = create(:admin)
    user = create(:user, :user5)
    teacher = create(:teacher)

    visit '/users/recover-password/new'
    fill_in 'email', with: user.email
    click_button 'Confirmar'

    open_email(user.email).click_link 'Mudar minha Senha'

    expect(page).to have_content 'Defina sua senha'
    fill_in 'password', with: '1234567'
    fill_in 'password2', with: '1234567'
    click_button 'Confirmar'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: user.email
    fill_in 'password', with: '1234567'
    click_button 'Confirmar'

    expect(page).to have_content 'Formulários Pendentes'
  end

  scenario 'admin forgot_password' do
    department = create(:department)
    admin = create(:admin)
    coordinator = create(:coordinator)

    visit '/admins/recover-password/new'
    fill_in 'email', with: admin.email
    click_button 'Confirmar'

    open_email(admin.email).click_link 'Mudar minha Senha'

    expect(page).to have_content 'Defina sua senha'
    fill_in 'password', with: '1234567'
    fill_in 'password2', with: '1234567'
    click_button 'Confirmar'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: '1234567'
    click_button 'Confirmar'

    expect(page).to have_content 'Coordenador'
  end
end

# token = user.send_reset_password_instructions
# put :update, params: { 'user' => {
#   'reset_password_token' => token,
#   'password' => '1234567', 'password_confirmation' => '1234567'
# } }
# put_update_with_params
