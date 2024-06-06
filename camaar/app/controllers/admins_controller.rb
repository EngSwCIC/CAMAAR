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

  def import
    json = params[:admin_import][:file].tempfile.path
    members = JSON.parse(File.read(json))
    members.each do |member|
      if member["ocupacao"] == "dicente"
          UsersMailer.register_user(member["email"]).deliver_now
      elsif member["ocupacao"] == "docente"
          UsersMailer.register_user(member["email"]).deliver_now
      end
    end   
  end
 # def envio
  #  UsersMailer.deliver
  #end
end
