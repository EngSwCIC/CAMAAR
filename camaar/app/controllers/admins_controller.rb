require 'json'

class AdminsController < ApplicationController
  layout 'admin'
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

  def import
    json = params[:admin_import][:file].tempfile.path
    selected_data = params[:select_data]

    if selected_data == '1'
      members = JSON.parse(File.read(json))
      members.each do |member|
        UsersMailer.register_user(member['docente']['email']).deliver
        member['discente'].each do |student|
          UsersMailer.register_user(student['email']).deliver
        end
      end

    elsif selected_data == '2'
      classes = JSON.parse(File.read(json))
      classes.each do |klass|
        teacher = Teacher.find_by(department_id: current_admin.department_id)
        SubjectClass.create!(
          code: klass['code'],
          name: klass['name'],
          semester: klass['semester'],
          created_at: Time.now.utc,
          updated_at: Time.now.utc,
          department_id: current_admin.department_id,
          initials: klass['code'].gsub(/[^a-zA-Z]/, ''),
          teacher_id: teacher.id
        )
      end

    elsif selected_data == '3'
      departamentos = JSON.parse(File.read(json))
      departamentos.each do |dpto|
        Department.create!(
          id: dpto['id'],
          initials: dpto['initials'],
          name: dpto['name']
        )
      end
    end
  end
end
