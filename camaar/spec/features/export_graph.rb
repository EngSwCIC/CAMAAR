require 'rails_helper'
require 'gruff'

RSpec.feature 'Export Graph', type: :feature do
  describe 'exporting answers as graph' do
    it 'should export a graph containing answers % by students' do

      # visit '/users/login'
      # user = create(:user)
      # expect(page).to have_content 'Bem vindo ao'
      # expect(page).to have_content 'CAMAAR'
      # fill_in 'email', with: user.email
      # fill_in 'password', with: user.password
      # click_button 'Confirmar'
      # expect(page).to have_content 'Formulários Pendentes'

      graph = Gruff::Pie.new
      graph.title = "Respostas do Formulário"

      department1 = create(:department)

      admin1 = create(:admin)

      student1 = create(:student, :student1)
      student2 = create(:student, :student2)
      student3 = create(:student, :student3)
      student4 = create(:student, :student4)

      coordinator1 = create(:coordinator)
      template = create (:template)

      subject_class1 = create(:subject_class)


      form = create(:form)


      answ1 = create(:student_answer, :student_answers1)
      answ2 = create(:student_answer, :student_answers2)
      answ3 = create(:student_answer, :student_answers3)

      graph.data 'Total de ausências', Student.count -  StudentAnswer.where(form_id: 0).count
      graph.data 'Total de respostas', StudentAnswer.where(form_id: 0).count
      graph.write('pie_graph.png')

    end
  end

end
