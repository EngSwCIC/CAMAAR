require 'rails_helper'

feature 'Dispatch forms' do
  background do
    # will clear the message queue
    clear_emails
  end
  describe 'happy path of dispatching form to student' do
    before do
      departament = create(:department, :departament1)
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator, :coordinator1)
      user = create(:user, :user4)
      student4 = create(:student, :student4)
      template = create(:template, :template1)
      template_questions = create(:template_question, :template_question1)
      user = create(:user, :user6)
      teacher = create(:teacher, :teacher2)
      subject_class1 = create(:subject_class, :subject_class2)
    end
    scenario 'admin can sends forms to students' do
      admin = build(:admin, :admin1)
      subject_class1 = build(:subject_class, :subject_class2)
      template = build(:template, :template1)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'

      click_link 'Envio'
      expect(page).to have_content('Opções para Envio')
      select 'Template1', from: 'aluno_template_id'
      page.check('BANCOS DE DADOS')
      click_button 'Enviar'
      expect(page).to_not have_content 'Selecione os templates.'
      expect(page).to have_content "Os formulários para a turma #{SubjectClass.find_by(id: subject_class1).name} foram criados com sucesso."
      expect(Form.where(name: template.name).count).to eq(1)
    end
  end

  describe 'sad path of dispatching form to student' do
    before do
      departament = create(:department, :departament1)
      admin = create(:admin, :admin1)
      coordinator = create(:coordinator, :coordinator1)
      user = create(:user, :user4)
      student4 = create(:student, :student4)
      template = create(:template, :template1)
      template_questions = create(:template_question, :template_question1)
      user = create(:user, :user6)
      teacher = create(:teacher, :teacher2)
      subject_class1 = create(:subject_class, :subject_class2)
    end
    scenario 'admin can sends forms to students' do
      admin = build(:admin, :admin1)
      subject_class1 = build(:subject_class, :subject_class2)
      template = build(:template, :template1)

      visit '/admins/login'

      expect(page).to have_content 'Bem vindo ao'
      expect(page).to have_content 'CAMAAR'
      fill_in 'email', with: admin.email
      fill_in 'password', with: admin.password
      click_button 'Confirmar'

      click_link 'Envio'
      expect(page).to have_content('Opções para Envio')
      select 'Template1', from: 'aluno_template_id'
      click_button 'Enviar'
      expect(page).to_not have_content 'Selecione os templates.'
      expect(page).to have_content 'Nenhum template disponível'
      expect(Form.where(name: template.name).count).to eq(0)
    end
  end
end
