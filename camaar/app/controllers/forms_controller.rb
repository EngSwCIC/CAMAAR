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

        @forms = if @filter == "pending"
            @pending_forms
          else
            @answered_forms
          end
      end
    end
  end

  def edit
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)

  end

  def update; end

  def show
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)

    @questions_and_answers = []
    @form_questions.each do |question|
      if current_user.occupation == "discente"
        answer = StudentAnswer.find_by({ student_id: @student.id, form_question_id: question.id })
        @questions_and_answers << [question, answer]
      else
        answer = TeacherAnswer.find_by({ teacher_id: @teacher.id, form_question_id: question.id })
        @questions_and_answers << [question, answer]
      end
    end
  end
end
