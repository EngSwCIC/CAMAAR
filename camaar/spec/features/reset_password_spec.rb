require 'rails_helper'

feature 'Reset Password' do
  background do
    # will clear the message queue
    clear_emails
  end

  scenario 'forgot_password' do
    user = User.create!({
                          email: 'test@gmail.com',
                          password: 'abc123',
                          password_confirmation: 'abc123',
                          confirmed_at: Time.now.utc
                        })

    visit '/users/recover-password/new'
    fill_in 'email', with: user.email
    click_button 'Confirmar'

    open_email(user.email).click_link 'Change my password'

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
end

# token = user.send_reset_password_instructions
# put :update, params: { 'user' => {
#   'reset_password_token' => token,
#   'password' => '1234567', 'password_confirmation' => '1234567'
# } }
# put_update_with_params
