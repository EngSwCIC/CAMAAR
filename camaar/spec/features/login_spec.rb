require 'rails_helper'

RSpec.feature 'Logins', type: :feature do
  describe 'teacher login' do
    before do
      department = create(:department, :departament1)
      admin = create(:admin, :admin1)
    end
    it 'should login teacher with username and password' do
      visit '/users/login'
      user = create(:user, :user5)
      teacher = create(:teacher,:teacher1)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Confirmar'
      expect(page).to have_content 'Formulários Pendentes'
      expect(page).to have_content 'Fernando'
      expect(page).to have_content 'Docente'
      expect(page).to have_content 'CIC'
    end
  end

  describe 'student login' do
    before do
      department = create(:department, :departament1)
      admin = create(:admin, :admin1)
    end
    it 'should login student with username and password' do
      visit '/users/login'
      user = create(:user, :user4)
      student = create(:student, :student4)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Confirmar'
      expect(page).to have_content 'Formulários Pendentes'
      expect(page).to have_content 'Caio'
      expect(page).to have_content 'Discente'
      expect(page).to have_content 'CIC'
    end
  end

  describe 'admin login' do
    before do
      department = create(:department, :departament1)
    end
    it 'should login admin with username and password' do
      visit '/admins/login'
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator,:coordinator1)

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
      expect(page).to have_content 'Coordenador'
    end
  end

  describe 'user cant login as admin' do
    before do
      department = create(:department, :departament1)
    end
    it 'should redirect to root page' do
      visit '/admins/login'
      user = create(:user, :user4)
      student = create(:student, :student4)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Confirmar'
      expect(page).to have_content 'Usuário'
      expect(page).to have_content 'Admin'
    end
  end

  describe 'admin cant login as user' do
    before do
      department = create(:department, :departament1)
    end
    it 'should redirect to root page' do
      visit '/users/login'
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator,:coordinator1)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
      expect(page).to have_content 'Usuário'
      expect(page).to have_content 'Admin'
    end
  end
end
