# Gerencia a importação de dados do SIGAA na área administrativa.
class Admin::ImportsController < Admin::BaseController
  # Exibe o formulário de importação de dados.
  def new
  end

  # Processa a importação dos arquivos JSON do SIGAA.
  #
  # Efeito colateral: invoca +SigaaImportService.processar+ que lê os
  # arquivos JSON e atualiza o banco de dados. Redireciona para
  # +admin_root_path+ com confirmação em caso de sucesso, ou renderiza
  # +:new+ com alerta detalhando o erro em caso de falha.
  def create
    SigaaImportService.processar
    redirect_to admin_root_path, notice: "Importação de dados concluída com sucesso"
  rescue StandardError => e
    flash.now[:alert] = "Erro ao processar os arquivos JSON: #{e.message}"
    render :new, status: :unprocessable_entity
  end
end
