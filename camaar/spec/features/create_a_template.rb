require 'rails_helper'

RSpec.feature 'Create a template', type: :feature do
  describe 'admin can create a template' do
    it 'should create a new template with a text answer' do
      department = create(:department,:departament1)
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator,:coordinator1)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'

      expect(page).to have_content 'Adicionar Template'
      click_button 'Adicionar Template'
      expect(page).to have_content 'Nome do template:'
      click_link 'add_question'

      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
      expect(page).to have_content 'Adicionar'
      expect(page).to have_content 'Cancelar'

      fill_in 'question_title', with: 'Tudo bem?'
      select('Texto', from: 'question_type')

      click_button 'Adicionar'
      expect(page).to have_content 'Questão 1'
      fill_in 'template[name]', with: 'test_temp'
      click_button 'Salvar'

      expect(Template.where(name: 'test_temp').count).to eq(1)

      template = Template.find_by(name: 'test_temp')

      expect(TemplateQuestion.find_by(template_id: template.id).question_type).to eq('text')
    end

    it 'should create a new template with a text answer' do
      department = create(:department,:departament1)
      admin = create(:admin,:admin1)
      coordinator = create(:coordinator,:coordinator1)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'

      expect(page).to have_content 'Adicionar Template'
      click_button 'Adicionar Template'
      expect(page).to have_content 'Nome do template:'
      click_link 'add_question'

      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
      expect(page).to have_content 'Adicionar'
      expect(page).to have_content 'Cancelar'

      fill_in 'question_title', with: 'Tudo bem?'

      # select('Múltipla escolha', from: 'question_type')
      # expect(page).to have_content 'Número de questões:'

      # select('2', from: 'options_number')

      # click_button 'Adicionar'
      # expect(page).to have_content 'Questão 1'
      # fill_in 'template[name]', with: 'test_temp2'
      # click_button 'Salvar'

      # expect(Template.where(name: "test_temp2").count).to eq(1)

      # template = Template.find_by(name: "test_temp2")

      # expect(TemplateQuestion.find_by(template_id:template.id).question_type).to eq("text")
    end
  end
end
