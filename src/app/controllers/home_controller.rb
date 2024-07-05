# Controlador para gerenciar as ações da página inicial
class HomeController < ApplicationController
  before_action :authenticate_user!

  ##
  # Exibe a página inicial com a lista de formulários
  def index
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
        .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
    Rails.logger.debug @formularios.inspect
  end

  ##
  # Exibe a página de gerenciamento de templates e turmas
  def gerenciamento
    @templates = current_user.templates
    @turmas = current_user.turmas_professor
  end

  ##
  # Exibe a página de resultados com a lista de formulários
  def resultados
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
        .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
    Rails.logger.debug @formularios.inspect
  end

  ##
  # Envia os formulários selecionados para as turmas especificadas
  #
  # +param+ [Array<Integer>] turma_ids - Os IDs das turmas para as quais os formulários serão enviados, obtido dos parâmetros
  # +param+ [Integer] template_id - O ID do template a ser usado para os formulários, obtido dos parâmetros
  # +effect_side+ Cria novos registros de formulários no banco de dados para as turmas especificadas e redireciona para a página de gerenciamento com uma mensagem de sucesso ou erro
  def enviar_formularios
    turma_ids = params[:turma_ids]
    template_id = params[:template_id]

    Rails.logger.debug "template_id: #{template_id.inspect}"
    Rails.logger.debug "turma_ids: #{turma_ids.inspect}"

    if template_id.blank?
      redirect_to gerenciamento_path, alert: "Template não selecionado!"
      return
    end

    if turma_ids.blank?
      redirect_to gerenciamento_path, alert: "Nenhuma turma selecionada!"
      return
    end

    turma_ids.each do |turma_id|
      formulario = Formulario.create(turma_id: turma_id, template_id: template_id, id_turma: turma_id, id_template: template_id, created_at: Time.current, updated_at: Time.current)
      
      if formulario.persisted?
        Rails.logger.debug "Formulário criado com sucesso: #{formulario.inspect}"
      else
        Rails.logger.error "Erro ao criar formulário: #{formulario.errors.full_messages.join(', ')}"
      end
    end

    redirect_to gerenciamento_path, notice: "Formulário(s) criado(s) com sucesso!"
  end
end