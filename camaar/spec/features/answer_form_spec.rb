require 'rails_helper'

feature 'Answer forms' do
  background do
    # will clear the message queue
    clear_emails
  end

  before do
    departament = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    user = create(:user, :user4)
    student4 = create(:student, :student4)
    template = create(:template, :template1)
    template_questions = create(:template_question, :template_question1)

    template2 = create(:template, :template2)
    template_question2 = create(:template_question, :template_question3)

    user = create(:user, :user6)
    teacher = create(:teacher, :teacher2)
    subject_class1 = create(:subject_class, :subject_class2)
    enrollment = create(:enrollment, :enrollment5)
    visit '/admins/login'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'
    click_link 'Envio'
    select 'Template1', from: 'aluno_template_id'
    select 'Template2', from: 'professor_template_id'
    page.check('BANCOS DE DADOS')
    click_button 'Enviar'
    click_link 'Sair'
  end
  scenario 'students can answer forms and view their answers' do
    visit '/users/login'
    user = build(:user, :user4)
    template = build(:template, :template1)
    template_question = build(:template_question, :template_question1)
    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Confirmar'

    expect(page).to have_content('Formulários Pendentes')

    click_link template.name
    expect(page).to have_content template.name
    expect(page).to have_content template_question.title

    classid = build(:subject_class, :subject_class2)
    form = Form.find_by(role: 'discente', subject_class_id: classid.id)
    form_question = FormQuestion.find_by(form_id: form.id, title: template_question.title)

    fill_in "questao_#{form_question.id}", with: 'fine'
    click_button 'Enviar'
    expect(page).to have_content 'Formulários Pendentes'
    expect(page).to_not have_content template.name
    click_link 'Respondidos'
    expect(page).to have_content template.name
    click_link template.name
    expect(page).to have_content template_question.title
    expect(page).to have_content 'fine'
  end

  scenario 'teachers can answer forms and view their answers' do
    visit '/users/login'
    user = build(:user, :user6)
    template = build(:template, :template2)
    template_question = build(:template_question, :template_question3)
    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'Confirmar'

    expect(page).to have_content('Formulários Pendentes')

    click_link template.name
    expect(page).to have_content template.name
    expect(page).to have_content template_question.title

    classid = build(:subject_class, :subject_class2)
    form = Form.find_by(role: 'docente', subject_class_id: classid.id)
    form_question = FormQuestion.find_by(form_id: form.id, title: template_question.title)

    fill_in "questao_#{form_question.id}", with: 'fine'
    click_button 'Enviar'
    expect(page).to have_content 'Formulários Pendentes'
    expect(page).to_not have_content template.name
    click_link 'Respondidos'
    expect(page).to have_content template.name
    click_link template.name
    expect(page).to have_content template_question.title
    expect(page).to have_content 'fine'
  end
end
