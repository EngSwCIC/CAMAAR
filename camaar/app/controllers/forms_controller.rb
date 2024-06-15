class FormsController < ApplicationController
  # before_action :set_admin_data

  # layout "user"

  layout "admin"

  def create
    set_admin_data
    @student_templates = Template.where({ coordinator_id: @coordinator.id, role: "discente" })
    @teacher_templates = Template.where({ coordinator_id: @coordinator.id, role: "docente" })

    professor_template_id = params[:professor_template_id]
    aluno_template_id = params[:aluno_template_id]
    turma_ids = params[:turma_ids]
    if turma_ids.present?
      turma_ids.each do |turma|
        if professor_template_id.present? and aluno_template_id.present?
          teacher_template = Template.find_by(id: professor_template_id, draft: false)
          unless Form.find_by(role: "teacher", name: template.name, coordinator_id: @coordinator.id, subject_class_id: turma).present?
            teacher_form = Form.new(
              role: teacher_template.role,
              name: teacher_template.name,
              coordinator_id: teacher_template.coordinator_id,
              subject_class_id: teacher_template.subject_class_id,
            )
          end

          student_template = Template.find_by(id: aluno_template_id)
          unless Form.find_by(role: "student", name: template.name, coordinator_id: @coordinator.id, subject_class_id: turma).present?
            student_form = Form.new(
              name: student_template.name,
              coordinator_id: student_template.coordinator_id,
              subject_class_id: student_template.subject_class_id,
            )
          end

          if teacher_form.save and student_form.save
            flash[:success] = "O formulário para a turma #{SubjectClass.find_by(id: turma).name} foi criado com sucesso."
          else
            flash[:warning] = "O formulário para a turma #{SubjectClass.find_by(id: turma).name} já existe."
          end
        end
      end
    end
  end

  def index
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
      @errors << "Nenhum formulário encontrado."
    else
      @forms = Form.where(subject_class_id: @subject_classes.pluck(:id), role: occupation)
    end
  end

  def edit
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)
  end

  def export(form)
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
