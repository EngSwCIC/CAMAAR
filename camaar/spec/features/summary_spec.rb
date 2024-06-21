require 'rails_helper'

RSpec.feature 'Results in graph and csv', type: :feature do
  before do
    department = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    user1 = create(:user, :user1)
    user2 = create(:user, :user2)
    user3 = create(:user, :user3)
    user4 = create(:user, :user4)
    user5 = create(:user, :user5)
    user6 = create(:user, :user6)
    student1 = create(:student, :student1)
    student2 = create(:student, :student2)
    student3 = create(:student, :student3)
    student4 = create(:student, :student4)
    template = create(:template, :template1)
    template_questions = create(:template_question, :template_question1)

    teacher = create(:teacher, :teacher1)
    teacher = create(:teacher, :teacher2)
    subject_class1 = create(:subject_class, :subject_class1)
    subject_class2 = create(:subject_class, :subject_class2)

    enrollment1 = create(:enrollment, :enrollment1)
    enrollment2 = create(:enrollment, :enrollment2)
    enrollment3 = create(:enrollment, :enrollment3)
    enrollment4 = create(:enrollment, :enrollment4)
    enrollment5 = create(:enrollment, :enrollment5)

    form = create(:form, :form4)
    form_question = create(:form_question, :form_question6)
    answer = create(:student_answer, :student_answers6)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'
  end
  describe 'admin can see summary of students forms' do
    before do
      form = create(:form, :form1)
      form2 = create(:form, :form3)
      form_question = create(:form_question, :form_question1)

      answ1 = create(:student_answer, :student_answers1)
      answ2 = create(:student_answer, :student_answers2)
      answ3 = create(:student_answer, :student_answers3)
      answ4 = create(:student_answer, :student_answers4)
      answ5 = create(:student_answer, :student_answers5)
    end
    it 'should see summary of text forms that were answered by students' do
      click_link 'Resultados'
      expect(page).to have_content 'Resultados'
      form = build(:form, :form1)
      form_question = build(:form_question, :form_question1)
      expect(page).to have_content form.name
      click_link form.name
      expect(page).to have_content form.name
      expect(page).to have_content form_question.title
    end

    it 'should see summary of multiple_choice forms that were answered by students' do
      click_link 'Resultados'
      expect(page).to have_content 'Resultados'
      form = build(:form, :form4)
      form_question = build(:form_question, :form_question6)
      expect(page).to have_content form.name
      click_link form.name
      expect(page).to have_content form.name
      expect(page).to have_content form_question.title
    end
  end
  describe 'admin can see summary of teachers forms' do
    before do
      form = create(:form, :form2)
      form_question = create(:form_question, :form_question2)
      teacher_answer = create(:teacher_answer, :teacher_answers1)
    end
    it 'should see summary of forms that were answered by teachers' do
      click_link 'Resultados'
      expect(page).to have_content 'Resultados'
      form = build(:form, :form2)
      expect(page).to have_content form.name
      click_link form.name
      expect(page).to have_content form.name
    end
  end
end
