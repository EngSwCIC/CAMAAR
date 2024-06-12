# app/controllers/imports_controller.rb
# inherits from ApplicationController
class ImportsController < ApplicationController
  def new
  end

  # handles the data import, calling the service and assessing a successfully of failed operation
  def create
    if params[:file].present?
      file_path = params[:file].path
      ImportCsvService.new(file_path).call
      redirect_to root_path, notice: 'CSV imported successfully'
    else
      redirect_to new_import_path, alert: 'Please upload a CSV file'
    end
  end
end
