class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
        .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
    Rails.logger.debug @formularios.inspect
  end

  def gerenciamento
    @templates = current_user.templates
    @turmas = current_user.turmas_professor
  end

  def resultados
    @formularios = Formulario.joins(turma: [:professor, :materia], template: [])
        .select('formularios.*, turmas.classCode as turma_classCode, turmas.semestre as turma_semestre, users.nome as professor_name, materias.nome as materia_nome')
    Rails.logger.debug @formularios.inspect
  end

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