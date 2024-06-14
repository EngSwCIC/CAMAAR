# require 'rails_helper'
# require 'gruff'

# RSpec.feature 'Export Graph', type: :feature do
#   describe 'exporting answers as graph' do
#     it 'should export a graph containing answers % by students' do
#       graph = Gruff::Pie.new
#       graph.title = 'Respostas do Formulário'

#       department = create(:department,:department1)

#       admin = create(:admin, :admin1)

#       user1 = create(:user, :user1)
#       user2 = create(:user, :user2)
#       user3 = create(:user, :user3)
#       user4 = create(:user, :user4)
#       user5 = create(:user, :user5)

#       student1 = create(:student, :student1)
#       student2 = create(:student, :student2)
#       student3 = create(:student, :student3)
#       student4 = create(:student, :student4)

#       coordinator = create(:coordinator)
#       template = create(:template)
#       template_questions = create(:template_question)

#       teacher = create(:teacher)
#       subject_class1 = create(:subject_class)

#       form = create(:form)
#       form_question = create(:form_question)

#       answ1 = create(:student_answer, :student_answers1)
#       answ2 = create(:student_answwwer, :student_answers2)
#       answ3 = create(:student_answer, :student_answers3)

#       num_students = Student.count
#       num_answers = StudentAnswer.where(form_question_id: form_question.id).count

#       graph.data 'Total de ausências', num_students - num_answers
#       graph.data 'Total de respostas', num_answers
#       graph.write('pie_graph.png')
#     end
#   end
# end
