require "json"

class AdminsController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
  before_action :set_admin_data

  def index
    @admin = Admin.new
    @admin = Admin.all
  end

  def login
    @admin = Admin.new
    @admin = Admin.all
  end

  def envio; end

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

        if not db_subject_class
          @errors << %'#{data["code"]}-#{data["classCode"]}-#{data["semester"]} Turma não foi encontrada'
          next
        end

        db_teacher = Teacher.find_by({ registration: data["docente"]["usuario"] })
        teacher_data = { name: data["docente"]["nome"],
                         formation: data["docente"]["formacao"],
                         registration: data["docente"]["usuario"],
                         occupation: data["docente"]["ocupacao"],
                         email: data["docente"]["email"],
                         department_id: Department.find_by(name: data["docente"]["departamento"]).id }
        if db_teacher
          db_teacher.update(teacher_data)
        else
          db_teacher = Teacher.create(teacher_data)
          UsersMailer.register_user(member["docente"]["email"]).deliver
        end
        db_subject_class.update({
          teacher_id: db_teacher.id,
        })

        data["discente"].each do |student|
          db_student = Student.find_by({ registration: student["matricula"] })
          student_data = { name: student["nome"],
                           course: student["curso"],
                           registration: student["matricula"],
                           formation: student["formacao"],
                           occupation: student["ocupacao"],
                           email: student["email"] }
          if db_student
            db_student.update(student_data)
          else
            db_student = Student.create(student_data)
            UsersMailer.register_user(student["email"]).deliver
          end

          db_enrollment = Enrollment.find_by({
            student_id: db_student.id,
            subject_class_id: db_subject_class.id,
          })
          if not db_enrollment
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
          department_id: Department.find_by(initials: initials).id,
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
      departamentos = JSON.parse(File.read(json))
      departamentos.each do |dpto|
        Department.create!(
          id: dpto["id"],
          initials: dpto["initials"],
          name: dpto["name"],
        )
      end
    end
  end

  # end
  # def envio
  #  UsersMailer.deliver
  #end
end
