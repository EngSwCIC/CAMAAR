require "json"

class AdminsController < ApplicationController
  def index
    @admin = Admin.new
    @admin = Admin.all
  end

  def login
    @admin = Admin.new
    @admin = Admin.all
  end

  # def enviar
  # @adminll = Admin.new
  # end

  def import
    json = params[:admin_import][:file].tempfile.path
    members = JSON.parse(File.read(json))
    members.each do |member|
      UsersMailer.register_user(member["docente"]["email"]).deliver
      member["discente"].each do |student|
        UsersMailer.register_user(student["email"]).deliver
      end
    end
  end

  # end
 # def envio
  #  UsersMailer.deliver
  #end
end
