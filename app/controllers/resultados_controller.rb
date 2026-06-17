require "csv"

class ResultadosController < ApplicationController
  before_action :require_admin_for_resultados, only: [ :show, :relatorios ]

  def index
    @formularios = Formulario.all
  end

  def show
    @formulario = Formulario.find(params[:id])
    @respostas = @formulario.respostas

    if @respostas.empty?
      @mensagem_aviso = "Este formulário ainda não recebeu respostas"
    end

    # Calculate average scores and group responses by question
    @perguntas_metricas = []
    @comentarios = []

    @formulario.template.perguntas.each do |pergunta|
      itens = RespostaItem.where(questao_template: pergunta, resposta: @respostas)

      if pergunta.tipo == "likert"
        valores = itens.pluck(:valor_numerico).compact
        media = valores.any? ? (valores.sum.to_f / valores.size).round(1) : 0.0

        # Calculate percentages
        distribuicao = {}
        (1..5).each do |num|
          count = valores.count(num)
          percentage = valores.any? ? (count.to_f / valores.size * 100).round : 0
          distribuicao[num] = percentage
        end

        @perguntas_metricas << {
          pergunta: pergunta,
          media: media,
          distribuicao: distribuicao,
          count: valores.size
        }
      else
        textos = itens.pluck(:valor_texto).reject(&:blank?)
        @comentarios << {
          pergunta: pergunta,
          respostas: textos
        }
      end
    end
  end

  def relatorios
    @formularios = Formulario.all
  end

  def export_csv_resultado
    # Security check matching Scenario 4
    unless logged_in? && current_user.perfil == "administrador"
      flash[:alert] = "Acesso negado. Apenas administradores podem gerar este relatório."
      redirect_to "/" and return
    end

    @formulario = Formulario.find(params[:id] || params[:formulario_id])
    template = @formulario.template
    formularios = template.formularios

    # Filter by class/turma if specified
    if params[:turma_id].present?
      formularios = formularios.where(turma_id: params[:turma_id])
    end

    # Check for empty responses across selected forms
    total_respostas_count = formularios.joins(:respostas).count
    if total_respostas_count == 0
      flash[:alert] = "Não há dados suficientes para gerar o relatório desta avaliação."
      redirect_to admin_relatorios_path and return
    end

    # Generate CSV with headers: "Matrícula", "Turma", "Disciplina", "Respostas"
    csv_data = CSV.generate(headers: true, col_sep: ",", encoding: "UTF-8") do |csv|
      csv << [ "Matrícula", "Turma", "Disciplina", "Respostas" ]

      formularios.each do |form|
        form.respostas.each do |resp|
          # Se há filtro de turma, verificar se a resposta é da turma selecionada
          if params[:turma_id].present?
            usuario_turmas = resp.usuario.matriculas.pluck(:turma_id)
            next unless usuario_turmas.include?(params[:turma_id].to_i)
          end

          resp.resposta_itens.each do |item|
            valor_resposta = if item.questao_template.tipo == "likert"
                               item.valor_numerico.to_s
            else
                               item.valor_texto
            end

            # Get the turma the student was enrolled in for this response
            aluno_turma = resp.usuario.matriculas.find_by(turma_id: form.turma_id)&.turma || form.turma

            csv << [
              resp.usuario.matricula || "Anônimo",
              aluno_turma.codigo_turma,
              aluno_turma.disciplina.nome,
              valor_resposta
            ]
          end
        end
      end
    end

    # Filename format: resultados_avaliacao_remota_cic_2023_2.csv
    safe_name = template.titulo.downcase.gsub(/[^a-z0-9]/, "_").squeeze("_")
    filename = "resultados_#{safe_name}.csv"

    flash[:notice] = "Relatório gerado com sucesso."
    send_data csv_data, filename: filename, type: "text/csv; charset=utf-8"
  end

  private

  def require_admin_for_resultados
    unless logged_in? && current_user.perfil == "administrador"
      flash[:alert] = "Acesso negado: Perfil não autorizado"
      redirect_to "/"
    end
  end
end
