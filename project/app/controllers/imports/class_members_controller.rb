module Imports
  class ClassMembersController < ApplicationController
    before_action :require_admin

    def create
      result = Sigaa::ClassMembersImporter.new(imported_by: current_user).call
      redirect_to root_path, notice: "Importacao concluida: #{result.created_users} usuarios criados"
    end
  end
end
