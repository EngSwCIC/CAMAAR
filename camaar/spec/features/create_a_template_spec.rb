require 'rails_helper'

RSpec.feature 'Create a template', type: :feature, js: true do
  before do
    department = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    template = create(:template, :template1)
    template_questions = create(:template_question, :template_question1)
    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'
  end
  describe 'admin can create a template with multiple-choice answer' do
    it 'should create a new template with a multiple-choice answer' do
      expect(page).to have_content 'ADICIONAR TEMPLATE'
      click_button 'ADICIONAR TEMPLATE'
      expect(page).to have_content 'Nome do template:'
      click_link 'add_question'

      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
      expect(page).to have_content 'Cancelar'

      fill_in 'question_title', with: 'Como está?'

      select('Múltipla escolha', from: 'question_type')
      expect(page).to have_content 'Número de opções:'

      select('2', from: 'options_number')

      fill_in 'option1', with: 'Sim'
      fill_in 'option2', with: 'Não'

      click_button 'Adicionar'
      expect(page).to have_content 'Questão 1'

      fill_in 'template[name]', with: 'test_temp2'
      click_button 'Salvar'

      expect(Template.where(name: 'test_temp2').count).to eq(1)

      template = Template.find_by(name: 'test_temp2')

      expect(TemplateQuestion.find_by(template_id: template.id).question_type).to eq('multiple_choice')
    end
  end
  describe 'admin can create a template with text answer' do
    it 'should create a new template with a text answer' do
      expect(page).to have_content 'ADICIONAR TEMPLATE'
      click_button 'ADICIONAR TEMPLATE'
      expect(page).to have_content 'Nome do template:'
      click_link 'add_question'
      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
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
  end

  describe 'admin can update a template question' do
    it 'should update a question' do
      template = build(:template, :template1)
      template_questions = build(:template_question, :template_question1)
      expect(page).to have_content template.name
      click_link template.name
      expect(page).to have_content template_questions.title
      click_link 'Editar'
      fill_in 'template_question_title', with: 'Você torce pro maior do sul? (Grêmio)?'
      click_button 'Salvar'
      expect(page).to have_content 'Questão 1'
      fill_in 'template[name]', with: 'test_temp'
      click_button 'Salvar'

      expect(Template.where(name: 'test_temp').count).to eq(1)

      template = Template.find_by(name: 'test_temp')

      expect(TemplateQuestion.find_by(template_id: template.id).question_type).to eq('text')
    end
  end
  describe 'sad path admin cant create a template with no options' do
    it 'should not create a template with no options' do
      expect(page).to have_content 'ADICIONAR TEMPLATE'
      click_button 'ADICIONAR TEMPLATE'
      expect(page).to have_content 'Nome do template:'
      fill_in 'template[name]', with: 'test_temp'
      click_button 'Salvar'

      expect(page).to have_content 'O template precisa conter pelo menos uma pergunta'
      expect(Template.where(name: 'test_temp').count).to eq(0)
    end
  end
  describe 'sad path admin cant create a template question with no options' do
    it 'should not create a template question with no options' do
      expect(page).to have_content 'ADICIONAR TEMPLATE'
      click_button 'ADICIONAR TEMPLATE'
      expect(page).to have_content 'Nome do template:'
      click_link 'add_question'
      expect(page).to have_content 'Título'
      expect(page).to have_content 'Tipo de questão:'
      expect(page).to have_content 'Cancelar'

      select('Texto', from: 'question_type')

      click_button 'Adicionar'
      expect(page).to have_content 'Questão precisa de um título'
    end
  end
end
