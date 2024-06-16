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
        flash[:error] = 'Você não é admin ROOT'
        return redirect_to '/admins/import'
      end
      root_cord = Coordinator.find_by(department_id: root_dpto.id)
      if root_cord.nil?
        flash[:error] = 'Você não é admin ROOT'
        return redirect_to '/admins/import'

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
        flash[:error] = 'Você não é admin ROOT'

      end
      redirect_to "/admins/import"
    end
  end
end
