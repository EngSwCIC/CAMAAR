# Namespace para os controllers do painel administrativo do sistema
module Admin
end

# Controller para criação de formulários de avaliação pelo administrador
class Admin::FormsController < ApplicationController
  before_action :require_admin
  layout "dashboard"

  # Lista os formulários ativos (ainda dentro do período de vigência)
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum (renderiza view)
  # Efeitos colaterais: Nenhum
  def index
    @forms = Form.includes(:template, :turmas).where("end_date > ?", Time.current).order(created_at: :desc)
  end

  # Cria um formulário baseado em template e o envia para as turmas selecionadas
  #
  # Argumentos: params[:template_id], params[:turma_ids] (array)
  # Retorno: Nenhum (redireciona)
  # Efeitos colaterais: Cria Form e associações com turmas no banco
  def create
    return redirect_missing_destinatario if params[:destinatario].blank?
    return redirect_missing_template if params[:template_id].blank?

    turma_ids = Array(params[:turma_ids]).reject(&:blank?)
    return redirect_missing_turmas if turma_ids.empty?

    deliver_form(params[:template_id], turma_ids)
  end

  private

  # Redireciona com erro quando tipo de destinatário não foi selecionado
  #
  # Argumentos: Nenhum
  # Retorno: ActionDispatch::Response (redirect)
  # Efeitos colaterais: Nenhum
  def redirect_missing_destinatario
    redirect_to admin_management_path, alert: "Selecione o tipo de destinatário (Dicentes ou Docentes)"
  end

  # Redireciona com erro quando template não foi selecionado
  #
  # Argumentos: Nenhum
  # Retorno: ActionDispatch::Response (redirect)
  # Efeitos colaterais: Nenhum
  def redirect_missing_template
    redirect_to admin_management_path, alert: "Selecione um template para o formulário"
  end

  # Redireciona com erro quando nenhuma turma foi selecionada
  #
  # Argumentos: Nenhum
  # Retorno: ActionDispatch::Response (redirect)
  # Efeitos colaterais: Nenhum
  def redirect_missing_turmas
    redirect_to admin_management_path, alert: "Selecione ao menos uma turma"
  end

  # Cria o formulário e associa às turmas selecionadas
  #
  # Argumentos: template_id (String), turma_ids (Array)
  # Retorno: ActionDispatch::Response (redirect)
  # Efeitos colaterais: Cria Form e registros em forms_turmas
  def deliver_form(template_id, turma_ids)
    template = Template.find_by(id: template_id)
    form     = Form.new(
      template:     template,
      start_date:   parse_date(params[:start_date])&.beginning_of_day,
      end_date:     parse_date(params[:end_date])&.end_of_day,
      destinatario: resolve_destinatario
    )

    if form.save
      form.turmas << Turma.where(id: turma_ids)
      redirect_to admin_management_path, notice: success_message(form.destinatario, turma_ids.size)
    else
      redirect_to admin_management_path, alert: form.errors.full_messages.to_sentence
    end
  end

  # Monta a mensagem de sucesso de acordo com o destinatário e a
  # quantidade de turmas selecionadas
  #
  # Argumentos: destinatario (String), quantidade_turmas (Integer)
  # Retorno: String
  def success_message(destinatario, quantidade_turmas)
    return "Formulário criado com sucesso para #{quantidade_turmas} turmas" if quantidade_turmas > 1

    destino = destinatario == "discente" ? "dicentes" : "docentes"
    "Formulário criado com sucesso para #{destino}"
  end

  # Resolve o público-alvo do formulário a partir do parâmetro enviado.
  #
  # Argumentos: Nenhum (lê params[:destinatario])
  # Retorno: String
  # Efeitos colaterais: Nenhum
  def resolve_destinatario
    valor = params[:destinatario].to_s.strip
    %w[discente docente].include?(valor) ? valor : "discente"
  end

  # Converte uma string de data (dd/mm/yyyy ou yyyy-mm-dd) em Date
  #
  # Argumentos: valor (String)
  # Retorno: Date ou nil
  # Efeitos colaterais: Nenhum
  def parse_date(valor)
    return nil if valor.blank?

    Date.strptime(valor, "%d/%m/%Y")
  rescue ArgumentError
    begin
      Date.parse(valor)
    rescue ArgumentError, TypeError
      nil
    end
  end
end
