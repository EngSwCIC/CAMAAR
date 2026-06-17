class Admin::ImportsController < Admin::BaseController
  def new
  end

  def create
    SigaaImportService.processar
    redirect_to admin_root_path, notice: "Importação de dados concluída com sucesso"
  rescue StandardError => e
    flash.now[:alert] = "Erro ao processar os arquivos JSON: #{e.message}"
    render :new, status: :unprocessable_entity
  end
end