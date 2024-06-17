class FormsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_data
  layout "user"

  def index
    @filter = params[:filter] || "pending"
    @errors = []

    occupation = current_user.occupation
    case occupation
    when "discente"
      @enrollments = Enrollment.where(student_id: @student.id)
      if @enrollments.empty?
        @errors << "Parece que você não está matriculado em nenhum disciplina."
      else
        @subject_classes = SubjectClass.where({ id: @enrollments.pluck(:subject_class_id) })
      end
    when "docente"
      @subject_classes = SubjectClass.where(teacher_id: @teacher.id)
    end

    if @subject_classes.blank?
      @forms = []
      @errors << "Usuário não está associado a nenhuma turma"
    else
      @forms = Form.where(subject_class_id: @subject_classes.pluck(:id), role: occupation)

      @pending_forms = []
      @answered_forms = []

      @forms.each do |form|
        @form_questions = FormQuestion.where(form_id: form.id)

        case occupation
        when "discente"
          answers = StudentAnswer.where(form_question_id: @form_questions.pluck(:id))
        when "docente"
          answers = TeacherAnswer.where(form_question_id: @form_questions.pluck(:id))
        end

        if answers.any?
          @answered_forms << form
        else
          @pending_forms << form
        end

        if @filter == "pending"
          @forms = @pending_forms
        else
          @forms = @answered_forms
        end
      end
    end
  end

  def edit
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)
  end

  def update
  end

  def show
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)

    @questions_and_answers = []
    @form_questions.each do |question|
      if current_user.occupation == "discente"
        answer = StudentAnswer.find_by({ student_id: @student.id, form_question_id: question.id })
        @questions_and_answers << [question, answer]
      else
        answer = StudentAnswer.find_by({ teacher_id: @teacher.id, form_question_id: question.id })
        @questions_and_answers << [question, answer]
      end
    end
  end

  def export_graph(form)
    create_graph(form)
    temp_file = Tempfile.new(["pie_graph", ".png"])
    graph.write(temp_file.path)
    send_file temp_file.path, type: "image/png", disposition: "attachment", filename: "pie_graph.png"
    temp_file.close
    temp_file.unlink
  end

  def create_graph(_form)
    # export a graph
    graph = Gruff::Pie.new
    graph.title = "Respostas do Formulário"
    num_students = Student.count
    num_answers = StudentAnswer.where(form_question_id: form_question.id).count
    graph.data "Total de ausências", num_students - num_answers
    graph.data "Total de respostas", num_answers
    graph.write("pie_graph.png")
  end
end
