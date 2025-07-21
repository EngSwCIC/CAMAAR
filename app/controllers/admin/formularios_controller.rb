class Admin::FormulariosController < ApplicationController
  layout "criar_formulario"

  ##
  # Exibe a página de criação de formulário.
  # Carrega os dados necessários (templates, matérias e turmas).
  # Inicializa um novo objeto Formulario.
  #
  # @return [void]
  #
  def new
    carregar_dados_formulario
    @formulario = Formulario.new
  end

  ##
  # Cria formulários com base no template selecionado e nas matérias escolhidas.
  #
  # @return [void]
  # Redireciona para a página de gerenciamento com aviso de sucesso
  # ou renderiza o formulário novamente com mensagem de erro.
  #
  # @note Efeitos colaterais:
  # - Salva novos registros no banco de dados (Formularios).
  # - Pode redirecionar ou renderizar `:new`.
  #

  def create
    carregar_dados_formulario

    return render_erro(:template, "Nenhum template selecionado") if params.dig(:formulario, :template_id).blank?
    return render_erro(:materia, "Nenhuma matéria foi selecionada") if params.dig(:formulario, :materia_ids).blank?

    template = Template.find(formulario_params[:template_id])
    created_forms = criar_formularios_para_materias(template)

    if created_forms.any?
      flash[:notice] = "Formulário enviado com sucesso"
      redirect_to admin_gerenciamento_path
    else
      flash.now[:alert] = "Erro ao salvar os formulários"
      render :new
    end
  end

  private

  ##
  # Carrega os dados necessários para a criação do formulário:
  # templates, matérias e suas respectivas turmas.
  #
  # @return [void]
  #

  def carregar_dados_formulario
    @templates = Template.all
    @materias = Materia.includes(:turmas).all
    @turmas_por_materia = @materias.index_with { |materia| materia.turmas.first }
  end
  ##
  # Verifica se o parâmetro de template está em branco.
  #
  # @return [Boolean]
  #
  def template_id_blank?
    formulario_params[:template_id].blank?
  end
  ##
  # Verifica se os IDs das matérias estão em branco.
  #
  # @return [Boolean]
  #
  def materia_ids_blank?
    formulario_params[:materia_ids].blank?
  end

##
    # Renderiza a tela de novo formulário com mensagens de erro e os dados necessários.
    #
    # @param tipo [Symbol] tipo de erro (:template ou :materia)
    # @param mensagem [String] mensagem de erro a ser exibida
    #
    # @return [void]
    # Renderiza a view `new.html.erb` com os dados e mensagem de erro.
    # Possui efeito colateral de exibição de mensagem e recarregamento da tela.
    #

  def render_erro(tipo, mensagem)
  @formulario ||= Formulario.new
  @templates = Template.all
  @materias = Materia.all
  @turmas_por_materia = Turma.includes(:materia).index_by(&:materia)
  instance_variable_set("@#{tipo}_error", mensagem)
  flash.now[:alert] = mensagem
  render :new
end


  ##
  # Cria formulários para cada matéria selecionada com base em um template.
  #
  # @param template [Template] o template usado como base para os formulários
  # @return [Array<Formulario>] lista de formulários criados com sucesso
  #
  # @note Efeitos colaterais:
  # - Salva novos registros de Formulario no banco.
  # - Pode interromper o processo caso alguma matéria não possua turma.
  #

  def criar_formularios_para_materias(template)
    formulario_params[:materia_ids].filter_map do |materia_id|
      criar_formulario_para_materia(template, materia_id)
    end
  end

##
# Cria um formulário para uma única matéria com base em um template.
#
# @param template [Template] template usado como base para o formulário
# @param materia_id [String] ID da matéria para a qual será criado o formulário
# @return [Formulario, nil] o formulário criado, ou nil se a matéria não tiver turma
#
# @note Efeitos colaterais:
# - Acessa o banco para buscar a matéria e sua turma.
# - Exibe alerta caso a matéria não tenha turma.
# - Salva o formulário no banco de dados.
#

  def criar_formulario_para_materia(template, materia_id)
    materia = Materia.find(materia_id)
    turma = materia.turmas.first

    return sem_turma_alerta(materia) unless turma

    formulario = construir_formulario(template, turma)
    formulario.save ? formulario : nil
  end

  ##
# Exibe alerta informando que a matéria não possui turma.
#
# @param materia [Materia] matéria sem turma
# @return [nil]
#
# @note Efeitos colaterais:
# - Define um flash de alerta com a mensagem de erro.
#

  def sem_turma_alerta(materia)
    flash.now[:alert] = "A matéria #{materia.nome} não possui turmas"
    nil
  end

  ##
# Constrói um novo objeto Formulario a partir do template e da turma.
#
# @param template [Template] template usado como base
# @param turma [Turma] turma associada ao formulário
# @return [Formulario] instância do formulário (não salva)
#

  def construir_formulario(template, turma)
    Formulario.new(
      ligacao_pergunta_id: template.ligacao_pergunta_id,
      turma_id: turma.id,
      nome: template.nome
    )
  end

  ##
  # Define os parâmetros permitidos para criação de formulários.
  #
  # @return [ActionController::Parameters]
  #
  def formulario_params
    params.require(:formulario).permit(:template_id, materia_ids: [])
  end
end
