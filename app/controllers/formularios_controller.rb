require 'csv'

class FormulariosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_formulario, only: %i[show relatorio]
  before_action :require_docente!, only: %i[new create relatorio]

  # GET /formularios
  # Docente: lista os formulários criados (issue #13).
  # Discente: lista formulários das suas turmas, separando pendentes e
  # respondidos (issue #8).
  def index
    if current_user.docente?
      @formularios = Formulario.includes(:turma, :template).order(created_at: :desc)
    else
      turma_ids = current_user.enrollments.discentes.pluck(:turma_id)
      formularios = Formulario.includes(:turma, :template).where(turma_id: turma_ids)
      @pendentes   = formularios.reject { |f| f.respondido_por?(current_user) }
      @respondidos = formularios.select { |f| f.respondido_por?(current_user) }
    end
  end

  # GET /formularios/new  (issue #7)
  def new
    @templates = Template.order(:nome)
    @turmas    = Turma.order(:code, :class_code)
  end

  # POST /formularios  (issue #7)
  # Cria um formulário por turma escolhida, baseado em um template.
  def create
    template = Template.find_by(id: params[:template_id])
    turma_ids = Array(params[:turma_ids]).reject(&:blank?)
    titulo = params[:titulo].presence

    if template.nil? || turma_ids.empty?
      redirect_to new_formulario_path, alert: "Selecione um template e ao menos uma turma." and return
    end

    criados = 0
    Formulario.transaction do
      turma_ids.each do |turma_id|
        Formulario.create!(
          template: template,
          turma_id: turma_id,
          titulo: titulo || template.nome,
          prazo: params[:prazo].presence
        )
        criados += 1
      end
    end

    redirect_to formularios_path, notice: "Formulário criado com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_formulario_path, alert: "Erro ao criar formulário: #{e.message}"
  end

  # GET /formularios/:id
  # Docente: resultados (issue #13). Discente: tela para responder (issue #2).
  def show
    if current_user.docente?
      render :resultados
    else
      @ja_respondido = @formulario.respondido_por?(current_user)
    end
  end

  # GET /formularios/:id/relatorio.csv  (issue #6 / #101)
  def relatorio
    respond_to do |format|
      format.csv do
        send_data gerar_csv(@formulario),
          filename: "relatorio_formulario_#{@formulario.id}.csv",
          type: "text/csv"
      end
    end
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  def require_docente!
    return if current_user&.docente?
    redirect_to formularios_path, alert: "Apenas administradores (docentes) podem acessar essa área."
  end

  # Monta o CSV com as respostas do formulário
  def gerar_csv(formulario)
    CSV.generate do |csv|
      csv << ["Formulário", formulario.titulo]
      csv << ["Turma", formulario.turma.nome_completo]
      csv << ["Respondentes", "#{formulario.total_respondentes} de #{formulario.total_participantes}"]
      csv << []
      csv << ["Questão", "Tipo", "Resposta"]

      formulario.questions.each do |question|
        respostas = formulario.respostas_da(question)
        if respostas.empty?
          csv << [question.enunciado, question.tipo, "(sem respostas)"]
        else
          respostas.each do |resposta|
            csv << [question.enunciado, question.tipo, resposta.valor]
          end
        end
      end
    end
  end
end
