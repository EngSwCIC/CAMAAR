require 'rails_helper'

RSpec.feature 'Logouts', type: :feature do
  describe 'teacher logout' do
    before do
      department = create(:department, :departament1)
      admin = create(:admin, :admin1)
      visit '/users/login'
      user = create(:user, :user5)
      teacher = create(:teacher, :teacher1)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'Confirmar'
    end
    it 'should logout teacher' do
      expect(page).to have_content 'Formulários Pendentes'
      expect(page).to have_content 'Fernando'
      expect(page).to have_content 'Docente'
      expect(page).to have_content 'CIC'
      click_link 'Sair'
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
    end
  end
  describe 'admin logout' do
    before do
      department = create(:department, :departament1)
      admin = create(:admin, :admin1)
      visit '/admins/login'
      coordinator = create(:coordinator, :coordinator1)
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'
    end
    it 'should logout admin' do
      expect(page).to have_content 'Templates Criados'
      expect(page).to have_content 'Mandelli'
      expect(page).to have_content 'Coordenador'
      expect(page).to have_content 'CIC'
      click_link 'Sair'
      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
    end
  end
end
