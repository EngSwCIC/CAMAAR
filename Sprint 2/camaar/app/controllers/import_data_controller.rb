class ImportDataController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  layout 'authenticated'

  def import
    result = ImportDataService.import_all

    if result[:success]
      redirect_to dashboard_path, notice: 'Dados importados com sucesso.'
    else
      redirect_to dashboard_path, alert: result[:error]
    end
  end

end