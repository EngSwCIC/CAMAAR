require 'rails_helper'

RSpec.feature 'Create a template', type: :feature do
  describe 'admin can create a template' do
    it 'should create a new template' do


      department = create(:department)
      admin = create(:admin)
      coordinator = create(:coordinator)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'

      expect(page).to have_content 'Adicionar Template'
      click_button 'Adicionar Template'
      expect(page).to have_content 'Nome do Template'
      fill_in 'template[name]', with: 'template'
      click_button 'Adicionar questão'

    end
  end

end
