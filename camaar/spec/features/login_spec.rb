require 'rails_helper'

RSpec.feature 'Logins', type: :feature do
  describe 'user login' do
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

  describe 'admin login' do
    it 'should login admin with username and password' do
      visit '/admins/login'
      admin = Admin.create!({
                            email: 'test@gmail.com',
                            password: 'abc123',
                            password_confirmation: 'abc123',
                            confirmed_at: Time.now.utc
                          })
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
      expect(page).to have_content 'Coordenador'
    end
  end
end
