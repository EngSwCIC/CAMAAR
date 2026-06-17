class AdminController < ApplicationController
  layout "gerenciamento"

  before_action :set_admin

  def avaliacoes
  end

  def gerenciamento
  end

  def resultados
    @admin = Administrador.find_by(id: session[:usuario_id])

    if @admin
      @formularios = Formulario.joins(turma: :disciplina).where(disciplinas: { departamento_id: @admin.departamento_id }).includes(turma: :disciplina)
    else
      redirect_to root_path, alert: "Acesso não autorizado."
    end
  end

  def exportar_csv
    @formulario = Formulario.find_by(id: params[:id])

    if @formulario
      # O .includes carrega o usuário e também os resposta_elems junto com seus respectivo elemento_form
      @respostas = RespostaForm.where(formulario_id: @formulario.id).includes(:usuario, resposta_elems: :elemento_form)

      if @formulario.resposta_forms.empty?
        redirect_to admin_resultados_path, alert: "Falha na exportação: Este formulário ainda não possui respostas registradas."
        return
      end

      respond_to do |format|
        format.csv do
          num_turma = @formulario.turma&.numero_da_turma&.parameterize(separator: "_") || "sem_turma"
          nome_materia = @formulario.turma&.disciplina&.nome&.parameterize(separator: "_") || "sem_materia"
          nome_arquivo = "formulario_#{@formulario.id}_turma_#{num_turma}_#{nome_materia}.csv"

          # Força o download
          response.headers["Content-Disposition"] = "attachment; filename=\"#{nome_arquivo}\""
        end
      end
    else
      redirect_to admin_resultados_path, alert: "Formulário não encontrado"
    end
  end

  def sincronizar_sigaa
    if request.get?
      render :sincronizar_sigaa
    elsif request.post?
      processar_sincronizacao
    end
  end

  private

  def set_admin
    @admin = Administrador.find(params[:admin_id])

    if @admin.id != session[:usuario_id]
      redirect_to inicio_path, alert: "Acesso negado! Você só pode acessar as suas próprias páginas."
    end
  end

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
        redirect_to admin_gerenciamento_path(@admin), notice: "alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso"
      else
        redirect_to admin_gerenciamento_path(@admin), notice: "alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso"
      end
    when /sucesso/i
      if acao == "importar"
        redirect_to admin_gerenciamento_path(@admin), notice: "As turmas, matérias e participantes do SIGAA estão presentes no sistema."
      else
        redirect_to admin_gerenciamento_path(@admin), notice: "As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA."
      end
    when /já existem/i
      redirect_to admin_gerenciamento_path(@admin), alert: "os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente"
    when /já estão atualizados/i
      redirect_to admin_gerenciamento_path(@admin), alert: "os dados do SIGAA já estão atualizados e não serão atualizados novamente"
    else
      nome_acao = acao == "importar" ? "importação" : "atualização"
      redirect_to admin_gerenciamento_path(@admin), alert: "erro informando que a #{nome_acao} falhou"
    end
  end
end
