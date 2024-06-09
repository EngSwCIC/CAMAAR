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
      expect(page).to have_content 'Nome do template:'
      fill_in 'template[name]', with: 'template'
      click_link 'add_question'

      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
      expect(page).to have_content 'Adicionar'
      expect(page).to have_content 'Cancelar'
      expect(page).to have_content 'Voltar'

      fill_in 'question_title', with: 'Tudo bem?'

      # select('Múltipla escolha', from: 'question_type')
      # select('2', from: 'options_number') not working

      select('Texto', from: 'question_type')

      click_button 'Adicionar'
      click_button 'Salvar'

      # expect(TemplateQuestion.find_by_id...)

    end
  end

end
