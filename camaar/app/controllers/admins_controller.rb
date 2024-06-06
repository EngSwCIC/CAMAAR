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

  def import(json)
    members = JSON.parse(File.read(json))
    members["dicente"].each do |student|
      UsersMailer.register_user(student["email"]).deliver_now
    end
    Users.Mailer.register_user(members["docente"]["email"]).deliver_now
  end   

 # def envio
  #  UsersMailer.deliver
  #end
end
