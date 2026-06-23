module Imports
  class SigaaController < ApplicationController
    before_action :require_admin

    def new
      @semesters = Sigaa::DataSynchronizer.available_semesters
      @semester = params[:semester].presence || @semesters.first
    end

    def create
      result = Sigaa::DataSynchronizer.new(semester: sync_params[:semester], imported_by: current_user).call

      if result.already_up_to_date?
        redirect_to imports_sigaa_path, notice: "A base de dados ja esta atualizada com o SIGAA para este periodo."
      else
        redirect_to imports_sigaa_path,
          notice: "Sincronizacao concluida. #{result.created_count} novos registros adicionados e #{result.updated_count} registros atualizados."
      end
    end

    private

    def sync_params
      params.require(:sigaa_sync).permit(:semester)
    end
  end
end
