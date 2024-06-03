require 'rails_helper'

RSpec.feature 'Logins', type: :feature do
  describe 'login' do
    it 'should login user with username and password' do
      visit '/users/login'
      user = User.create!({
                            email: 'test@gmail.com',
                            password: 'abc123',
                            password_confirmation: 'abc123',
                            confirmed_at: Time.now.utc
                          })
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Confirmar'
      expect(page).to have_content 'Formulários Pendentes'
    end
  end
end
