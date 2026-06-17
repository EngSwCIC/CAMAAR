module Admin
  class DashboardController < ApplicationController
    before_action :require_admin
    layout "gerenciamento"

    def index
      @workspace = workspace
      @forms = @workspace.forms
    end

    def gerenciamento
    end

    def sincronizar_sigaa
      if request.get?
        render :sincronizar_sigaa
      elsif request.post?
        processar_sincronizacao
      end
    end

    private

    def processar_sincronizacao
      acao = params[:acao]
      arquivo = params[:arquivo_sigaa]

      unless arquivo.present?
        redirect_to admin_gerenciamento_path, alert: "Por favor, selecione um arquivo"
        return
      end

      temp_file = arquivo.path
      resultado = case acao
      when "importar"
                    SigaaImporter.import_from_files(temp_file, temp_file)
      when "atualizar"
                    SigaaImporter.update_from_files(temp_file, temp_file)
      else
                    "ação inválida"
      end

      processar_resultado(resultado, acao)
    end

    def processar_resultado(resultado, acao)
      case resultado
      when /alguns dados/i
        if acao == "importar"
          redirect_to admin_gerenciamento_path, notice: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso"
        else
          redirect_to admin_gerenciamento_path, notice: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso"
        end
      when /sucesso/i
        if acao == "importar"
          redirect_to admin_gerenciamento_path, notice: "As turmas, matérias e participantes do SIGAA estão presentes no sistema."
        else
          redirect_to admin_gerenciamento_path, notice: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA."
        end
      when /já existem/i
        redirect_to admin_gerenciamento_path, alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
      when /já estão atualizados/i
        redirect_to admin_gerenciamento_path, alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
      else
        nome_acao = acao == "importar" ? "importação" : "atualização"
        redirect_to admin_gerenciamento_path, alert: "erro informando que a #{nome_acao} falhou"
      end
    end
  end
end
