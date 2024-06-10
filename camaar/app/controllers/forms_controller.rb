class FormsController < ApplicationController
  def index; end

  def edit; end

  def export(form)
    create_graph(form)
    temp_file = Tempfile.new(['pie_graph', '.png'])
    graph.write(temp_file.path)
    send_file temp_file.path, type: 'image/png', disposition: 'attachment', filename: 'pie_graph.png'
    temp_file.close
    temp_file.unlink
  end

  def create_graph(_form)
    # export a graph
    graph = Gruff::Pie.new
    graph.title = 'Respostas do Formulário'
    num_students = Student.count
    num_answers = StudentAnswer.where(form_question_id: form_question.id).count
    graph.data 'Total de ausências', num_students - num_answers
    graph.data 'Total de respostas', num_answers
    graph.write('pie_graph.png')
  end
end
