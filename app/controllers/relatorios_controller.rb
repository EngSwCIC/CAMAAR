require "csv"

class RelatoriosController < ApplicationController
  before_action :require_login
  before_action :authorize_relatorios_index, only: [:index]
  before_action :require_admin, only: [:show, :export_csv]
  before_action :set_formulario, only: [:show, :export_csv]

  def index
    if current_usuario.admin?
      @formularios = Formulario.includes(:resposta_formularios).order(:nome_formulario)
    else
      turma_ids = current_usuario.professor&.turma_ids || []
      @formularios = Formulario.where(turma_id: turma_ids).includes(:resposta_formularios).order(:nome_formulario)
    end
  end

  def show
    @pergunta_formularios = @formulario.pergunta_formularios.order(:created_at)
    @total_respostas = @formulario.resposta_formularios.count
  end

  def export_csv
    respostas = @formulario.resposta_formularios.includes(:usuario)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Usuário", "Email", "Data de envio"]
      respostas.each do |resposta|
        csv << [
          resposta.usuario.nome,
          resposta.usuario.email,
          resposta.created_at.strftime("%d/%m/%Y %H:%M")
        ]
      end
    end

    send_data csv_data,
      filename: "relatorio_#{@formulario.id}_#{Date.today}.csv",
      type: "text/csv",
      disposition: "attachment"
  end

  private

  def authorize_relatorios_index
    if current_usuario.estudante?
      render plain: "Acesso negado, a visualização de resultados requer privilégios de administrador. Usuário não tem as permissões necessárias para acessar a página.",
             status: :forbidden
      return
    end

    if current_usuario.professor?
      turma_ids = current_usuario.professor&.turma_ids || []
      if Formulario.where(turma_id: turma_ids).empty?
        redirect_to root_path, alert: "Usuário não tem as permissões necessárias para acessar a página."
      end
    end
  end

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
