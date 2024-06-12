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
    json = params[:admin_import][:file].tempfile.path
    selected_data = params[:select_data]

    case selected_data
    when "1"
      members = JSON.parse(File.read(json))
      members.each do |member|
        UsersMailer.register_user(member["docente"]["email"]).deliver
        member["discente"].each do |student|
          UsersMailer.register_user(student["email"]).deliver
        end
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
      redirect_to subject_classes_path
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
