class GerenciamentoController < ApplicationController
  before_action :require_login, only: [ :formularios, :criar_formulario, :importar, :limpar ]
  before_action :autorizar_administrador, only: [ :formularios, :criar_formulario, :importar, :limpar ]

  def index
  end

  def importar
    classes_file = params[:classes_file]
    members_file = params[:members_file]

    if classes_file.blank? || members_file.blank?
      return redirect_to gerenciamento_path, alert: "Selecione os dois arquivos JSON para importar."
    end

    classes_data = JSON.parse(classes_file.read)
    members_data = JSON.parse(members_file.read)
    result = ImportarDadosService.new(classes_data, members_data, base_url: request.base_url).call

    if result[:success]
      redirect_to gerenciamento_path, notice: "Importação concluída. #{result[:summary]}"
    else
      redirect_to gerenciamento_path, alert: "Erro na importação: #{result[:errors].join(', ')}"
    end
  rescue JSON::ParserError => e
    redirect_to gerenciamento_path, alert: "Arquivo JSON inválido: #{e.message}"
  end

  def templates
    @template_formularios = TemplateFormulario.order(:nome_template)
  end

  def formularios
    preparar_formulario
  end

  def criar_formulario
    preparar_formulario
    @formulario.assign_attributes(formulario_params)
    @formulario.publico_estudante = publico_estudante
    @formulario.criador_formulario = current_usuario.criador_formulario

    unless @formulario.criador_formulario
      @formulario.errors.add(:base, "Administrador não possui perfil de criador de formulários.")
      return render :formularios, status: :unprocessable_content
    end

    if @formulario.save(context: :criacao_por_publico)
      redirect_to enviar_formularios_path, notice: "Formulário criado com sucesso."
    else
      render :formularios, status: :unprocessable_content
    end
  end

  def limpar
    result = LimparDadosService.new.call
    if result[:success]
      redirect_to gerenciamento_path, notice: "Dados removidos. O banco está pronto para nova importação."
    else
      redirect_to gerenciamento_path, alert: "Erro ao limpar dados: #{result[:error]}"
    end
  end

  def resultados
  end

  private

  def preparar_formulario
    @formulario ||= Formulario.new
    @templates = TemplateFormulario.order(:nome_template)
    @turmas = Turma.includes(:materia).order(:semestre_string, :numero_turma)
    @sem_templates = @templates.none?
  end

  def formulario_params
    params.require(:formulario).permit(:nome_formulario, :template_formulario_id, :turma_id)
  end

  def publico_estudante
    case params.dig(:formulario, :publico_alvo)
    when "discente" then true
    when "docente" then false
    end
  end

  def autorizar_administrador
    return if current_usuario&.admin?

    render plain: "Acesso negado, a criação de formulários requer privilégios de administrador",
           status: :forbidden
  end
end
