class Admin::ImportsController < ApplicationController
  layout 'dashboard'
  before_action :require_admin
  
  def index
  end

  def create
    if params[:file].nil?
      flash[:alert] = "Por favor, selecione um arquivo para importar"
      redirect_to admin_imports_path and return
    end

    file_content = params[:file].read
    
    if params[:file].content_type != 'application/json' && !params[:file].original_filename.end_with?('.json')
      flash[:alert] = "Formato de arquivo inválido. Por favor, envie um arquivo .json"
      redirect_to admin_imports_path and return
    end

    result = if params[:import_type] == 'classes'
               SigaaImporter.import_classes(file_content)
             else
               SigaaImporter.import_members(file_content)
             end

    if result[:success]
      flash[:notice] = result[:message]
    else
      flash[:alert] = result[:message]
    end

    redirect_to admin_imports_path
  end
end
