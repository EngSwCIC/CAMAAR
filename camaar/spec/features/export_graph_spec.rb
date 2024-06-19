require 'rails_helper'
# require 'gruff'
require 'rchart'
RSpec.feature 'Export Graph', type: :feature do
  describe 'exporting answers as graph' do
    before do
      department = create(:department, :departament1)

      admin = create(:admin, :admin1)

      user1 = create(:user, :user1)
      user2 = create(:user, :user2)
      user3 = create(:user, :user3)
      user4 = create(:user, :user4)
      user5 = create(:user, :user5)

      student1 = create(:student, :student1)
      student2 = create(:student, :student2)
      student3 = create(:student, :student3)
      student4 = create(:student, :student4)

      coordinator = create(:coordinator, :coordinator1)
      template = create(:template, :template1)
      template_questions = create(:template_question, :template_question1)

      teacher = create(:teacher, :teacher1)
      subject_class1 = create(:subject_class, :subject_class1)

      form = create(:form, :form1)
      form_question = create(:form_question, :form_question1)

      answ1 = create(:student_answer, :student_answers1)
      answ2 = create(:student_answer, :student_answers2)
      answ3 = create(:student_answer, :student_answers3)
    end
    it 'should export a graph containing answers % by students' do
      form_question = build(:form_question, :form_question1)
      form = build(:form, :form1)
      num_students = Student.count
      num_answers = StudentAnswer.where(form_question_id: form_question.id).count
      num_absents = num_students - num_answers

      p = Rdata.new
      p.add_point([num_answers, num_absents], 'Serie1')
      p.add_point(%w[Respostas Ausências], 'Serie2')
      p.add_all_series
      p.set_abscise_label_serie('Serie2')

      ch = Rchart.new(300, 200)
      ch.set_font_properties('tahoma.ttf', 8)
      ch.draw_filled_rounded_rectangle(7, 7, 293, 193, 5, 240, 240, 240)
      ch.draw_rounded_rectangle(5, 5, 295, 195, 5, 230, 230, 230)

      # Draw the pie chart
      ch.antialias_quality = 0
      ch.set_shadow_properties(2, 2, 200, 200, 200)
      ch.draw_flat_pie_graph_with_shadow(p.get_data, p.get_data_description, 120, 100, 60, Rchart::PIE_PERCENTAGE, 8)
      ch.clear_shadow

      ch.draw_pie_legend(210, 35, p.get_data, p.get_data_description, 250, 250, 250)

      ch.render_png(form.name)
    end
  end
end
