require "json"

class AdminsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_admin_data
  before_action :load

  def index
    @admin = Admin.new
    @admin = Admin.all
  end

  def login
    @admin = Admin.new
    @admin = Admin.allf
  end

  def load
    @templates = Template.where(coordinator_id: @coordinator.id, draft: false)
    @classes = SubjectClass.all
  end

  def envio
    @student_templates = Template.where({ coordinator_id: @coordinator.id, role: "discente" })
    @teacher_templates = Template.where({ coordinator_id: @coordinator.id, role: "docente" })

    flash.clear
    professor_template_id = params[:professor_template_id]
    aluno_template_id = params[:aluno_template_id]
    turma_ids = params[:turma_ids]

    commit = params[:commit]
    if commit == "confirm"
      if turma_ids.present?
        turma_ids.each do |subject_class_id|
          if professor_template_id.present? and aluno_template_id.present?
            subject_class_forms = Form.where(subject_class_id: subject_class_id)

            if subject_class_forms.empty?
              teacher_template = Template.find_by(id: professor_template_id, draft: false)
              teacher_form = Form.new(
                role: teacher_template.role,
                name: teacher_template.name,
                coordinator_id: teacher_template.coordinator_id,
                subject_class_id: subject_class_id,
              )

              student_template = Template.find_by(id: aluno_template_id)
              student_form = Form.new(
                name: student_template.name,
                coordinator_id: student_template.coordinator_id,
                subject_class_id: subject_class_id,
              )

              if teacher_form.save and student_form.save
                teacher_template_questions = TemplateQuestion.where({ template_id: teacher_template.id })
                teacher_template_questions.each do |question|
                  FormQuestion.create({
                                        title: question.title,
                                        body: question.body,
                                        question_type: question.question_type,
                                        form_id: teacher_form.id,
                                      })
                end

                student_template_questions = TemplateQuestion.where({ template_id: student_template.id })
                student_template_questions.each do |question|
                  FormQuestion.create({
                                        title: question.title,
                                        body: question.body,
                                        question_type: question.question_type,
                                        form_id: student_form.id,
                                      })
                end

                flash[:success] = "Os formulários para a turma #{SubjectClass.find_by(id: subject_class_id).name} foram criados com sucesso."
              end
            else
              flash[:warning] = "Os formulários para a turma #{SubjectClass.find_by(id: subject_class_id).name} já existem."
            end
          else
            flash[:warning] = "Selecione os templates para envio."
          end
        end
      else
        flash[:warning] = "Selecione as turmas para envio."
      end
    end
  end

  def import
    @errors = []
    json = params[:admin_import][:file].tempfile.path
    selected_data = params[:select_data]

    case selected_data
    when "1"
      members = JSON.parse(File.read(json))

      members.each do |data|
        db_subject_class = SubjectClass.find_by(
          { subject: data["code"],
            code: data["classCode"],
            semester: data["semester"] }
        )

        unless db_subject_class
          @errors << %(#{data["code"]}-#{data["classCode"]}-#{data["semester"]} Turma não foi encontrada)
          next
        end

        db_teacher = Teacher.find_by({ registration: data["docente"]["usuario"] })
        user_teacher = User.find_by(email: data["docente"]["email"])

        teacher_data = { name: data["docente"]["nome"],
                         formation: data["docente"]["formacao"],
                         registration: data["docente"]["usuario"],
                         occupation: data["docente"]["ocupacao"],
                         email: data["docente"]["email"],
                         department_id: Department.find_by(name: data["docente"]["departamento"]).id }
        if user_teacher
          db_teacher.update(teacher_data)
        elsif db_teacher
          UsersMailer.register_user(data["docente"]["email"]).deliver
        else
          db_teacher = Teacher.create(teacher_data)
          UsersMailer.register_user(data["docente"]["email"]).deliver
        end
        db_subject_class.update({
                                  teacher_id: db_teacher.id,
                                })

        data["discente"].each do |student|
          db_student = Student.find_by({ registration: student["matricula"] })
          user_student = User.find_by(email: student["email"])

          student_data = { name: student["nome"],
                           course: student["curso"],
                           registration: student["matricula"],
                           formation: student["formacao"],
                           occupation: student["ocupacao"],
                           email: student["email"] }

          if user_student
            db_student.update(student_data)
          elsif db_student
            UsersMailer.register_user(student["email"]).deliver
          else
            db_student = Student.create(student_data)
            UsersMailer.register_user(student["email"]).deliver
          end

          db_enrollment = Enrollment.find_by({
                                               student_id: db_student.id,
                                               subject_class_id: db_subject_class.id,
                                             })
          unless db_enrollment
            Enrollment.create({ student_id: db_student.id,
                                subject_class_id: db_subject_class.id })
          end
        end
        flash[:notice] = "Membros importados com sucesso"
        redirect_to "/admins/import"
      end
    when "2"
      classes = JSON.parse(File.read(json))

      classes.each do |subject_class|
        initials = subject_class["code"].gsub(/[^a-zA-Z]/, "")
        keys = { subject: subject_class["code"],
                 code: subject_class["class"]["classCode"],
                 semester: subject_class["class"]["semester"] }
        imported_data = {
          name: subject_class["name"],
          schedule: subject_class["class"]["time"],
          department_id: Department.find_by(initials:).id,
        }

        db_subject_class = SubjectClass.find_by(keys)

        if db_subject_class
          db_subject_class.update(
            imported_data
          )
        else
          SubjectClass.create(
            keys.merge(imported_data)
          )
        end
      end
      flash[:notice] = "Turmas importadas com sucesso"
      redirect_to "/admins/import"
    when "3"
      root_dpto = Department.find_by(initials: "ROOT")
      if root_dpto.nil?
        flash[:error] = "Você não é admin ROOT"
        return redirect_to "/admins/import"
      end
      root_cord = Coordinator.find_by(department_id: root_dpto.id)
      if root_cord.nil?
        flash[:error] = "Você não é admin ROOT"
        return redirect_to "/admins/import"
      end
      if current_admin.email == root_cord.email
        departamentos = JSON.parse(File.read(json))
        departamentos.each do |dpto|
          Department.create!(
            id: dpto["id"],
            initials: dpto["initials"],
            name: dpto["name"],
          )
        end
      else
        flash[:error] = "Você não é admin ROOT"
      end
      redirect_to "/admins/import"
    end
  end

  def results
    @forms = Form.where(coordinator_id: @coordinator.id)

    answered_forms = []
    @forms.each do |form|
      @form_questions = FormQuestion.where(form_id: form.id)

      occupation = form.role
      case occupation
      when "discente"
        answers = StudentAnswer.where(form_question_id: @form_questions.pluck(:id))
      when "docente"
        answers = TeacherAnswer.where(form_question_id: @form_questions.pluck(:id))
      end

      if answers.any?
        answered_forms << form
      end
    end
    @forms = answered_forms

    @form = Form.find_by_id(params[:form_id]) if params[:form_id]
    @form_questions = FormQuestion.where(form_id: @form.id) if @form
    case params[:export]
    when "csv"
      export_to_csv
    when "graph"
      @form = Form.find_by_id(params[:form_id])
      @form_questions = FormQuestion.where(form_id: @form.id)
      export_to_png
    end
  end

  def summary
    @form = Form.find_by_id(params[:id])
    @form_questions = FormQuestion.where(form_id: @form.id)
    @form_summary = generate_summary
  end

  def generate_summary
    resumo = {}

    @form_questions.each do |question|
      if @form.role == "discente"
        answers = StudentAnswer.where(form_question_id: question.id)
      else
        answers = TeacherAnswer.where(form_question_id: question.id)
      end

      question_body = JSON.parse(question.body)
      answers.each do |answ|
        answer_body = JSON.parse(answ.answers)["answers"]

        case question.question_type
        when "text"
          resumo[question.title] ||= []
          resumo[question.title] << answer_body
        when "multiple_choice"
          resumo[question.title] ||= {}
          question_body["options"].each do |option|
            if option[1] != ""
              resumo[question.title][option[1]] ||= 0
            end
          end

          answer_body.each do |k, selected|
            resumo[question.title][question_body["options"][k]] += 1 if selected
          end
        end
      end
    end

    return resumo
  end

  def export_to_csv
    csv_string = generate_csv
    csv_data = CSV.parse(csv_string, headers: true)

    file_path = Rails.root.join("export", "#{@form.id}_#{@form.name}_results.csv")
    directory_path = File.dirname(file_path)
    FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)

    CSV.open(file_path, "w") do |csv|
      csv << csv_data.headers

      csv_data.each do |row|
        csv << row
      end
    end

    send_file file_path, filename: "#{@form.id}_#{@form.name}_results.csv", type: "text/csv"
  end

  def export_to_png
    graph = generate_graph

    filename = @form.name + ".png"

    destination_path = File.join("export", filename)

    # Render and save the PNG file to the specified destination
    ch.render_png(destination_path)
  end

  def generate_graph
    if @form.role == 'discente'
    enrollments = Enrollment.where(subject_class_id: @form.subject_class_id)
    number_of_students = enrollments.distinct.count(:student_id)
    num_answers = StudentAnswer.where(student_id: enrollments.distinct.pluck(:student_id)).count
    num_absents = number_of_students - num_answers
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

    # ch.render_png(@form.name)

    elsif @form.role == 'docente'
      form_questions = FormQuestion.where(form_id: @form.id)
      form_question_ids = form_questions.pluck(:id)
      teacher_answers = TeacherAnswer.where(form_question_id: form_question_ids)

      text_answers = teacher_answers.where(question_type: "text")
      multiple_choice_answers = teacher_answers.where(question_type: "multiple_question")

      p = Rdata.new
      p.add_point([text_answers, multiple_choice_answers], 'Serie1')
      p.add_point(%w[Texto Múltipla-Escolha], 'Serie2')
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

      # ch.render_png(@form.name)
    end
    ch
  end

  def generate_csv
    table = []
    @form_questions.each do |question|
      if @form.role == "discente"
        answers = StudentAnswer.where(form_question_id: question.id)
      else
        answers = TeacherAnswer.where(form_question_id: question.id)
      end

      line = [question.title]

      answers.each do |answ|
        answer_body = JSON.parse(answ.answers)["answers"]
        case question.question_type
        when "text"
          line << answer_body
        when "multiple_choice"
          answer_body.each do |num, selected|
            line << num.to_i if selected
          end
        end
      end
      table << line
    end

    head = ["Questão"]
    (table[0].length - 1).times do |i|
      head << "Resposta #{i + 1}"
    end
    table.unshift(head)

    csv_string = CSV.generate do |csv|
      table.each do |row|
        csv << row
      end
    end
    return csv_string
  end
end