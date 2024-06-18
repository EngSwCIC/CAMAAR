require 'rails_helper'
require 'csv'
require 'rchart'

RSpec.feature 'Delete a template', type: :feature do
  before do
    department = create(:department, :departament1)
    admin = create(:admin, :admin1)
    coordinator = create(:coordinator, :coordinator1)
    user1 = create(:user, :user1)
    user2 = create(:user, :user2)
    user3 = create(:user, :user3)
    user4 = create(:user, :user4)
    user5 = create(:user, :user5)
    student1 = create(:student, :student1)
    student2 = create(:student, :student2)
    student3 = create(:student, :student3)
    student4 = create(:student, :student4)
    template = create(:template, :template1)
    template_questions = create(:template_question, :template_question1)

    teacher = create(:teacher, :teacher1)
    subject_class1 = create(:subject_class, :subject_class1)

    enrollment1 = create(:enrollment,:enrollment1)
    enrollment2 = create(:enrollment,:enrollment2)
    enrollment3 = create(:enrollment,:enrollment3)
    enrollment4 = create(:enrollment,:enrollment4)

    form = create(:form, :form1)
    form_question = create(:form_question, :form_question1)

    answ1 = create(:student_answer, :student_answers1)
    answ2 = create(:student_answer, :student_answers2)
    answ3 = create(:student_answer, :student_answers3)

    visit '/admins/login'

    expect(page).to have_content 'Bem vindo ao'
    expect(page).to have_content 'CAMAAR'
    fill_in 'email', with: admin.email
    fill_in 'password', with: admin.password
    click_button 'Confirmar'
  end
  describe 'admin can export a graph with stats ' do
    it 'should export a graph with stats of questions' do
      click_link 'Resultados'
      expect(page).to have_content 'Resultados'
      form = build(:form, :form1)
      expect(page).to have_content form.name
      click_link 'export-graph'
    end
  end
  describe 'admin can export a csv with answers ' do
    it 'should export a csv with answers of questions' do
      click_link 'Resultados'
      expect(page).to have_content 'Resultados'
      form = build(:form, :form1)
      expect(page).to have_content form.name
      click_link 'export-csv'
    end
  end
end
