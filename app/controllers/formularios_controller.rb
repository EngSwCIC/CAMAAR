class FormulariosController < ApplicationController
  before_action :require_admin

  def new
    @templates = Template.all
    @turmas = Turma.all
    @formulario = Formulario.new
  end

  def create
    # Normalize público-alvo
    p_alvo = params[:publico_alvo] || params[:formulario]&.[](:publico_alvo)
    if p_alvo.present?
      if p_alvo.to_s.downcase.include?("discente")
        p_alvo = "discente"
      elsif p_alvo.to_s.downcase.include?("docente")
        p_alvo = "docente"
      end
    end

    template_id = params[:template_id] || params[:formulario]&.[](:template_id)
    template = Template.find_by(id: template_id)

    status_val = params[:status] || params[:formulario]&.[](:status) || "aberto"

    data_in = params[:data_inicio] || params[:formulario]&.[](:data_inicio)
    data_lim = params[:data_limite] || params[:formulario]&.[](:data_limite)

    # Convert dates to active support time if string
    begin
      data_in = Time.parse(data_in) if data_in.is_a?(String) && data_in.present?
      data_lim = Time.parse(data_lim) if data_lim.is_a?(String) && data_lim.present?
    rescue => e
      # ignore parsing error, let validation catch it
    end

    # Check if we are doing single form creation (via turma_id)
    turma_id = params[:turma_id] || params[:formulario]&.[](:turma_id)

    if turma_id.present?
      # Single Formulario creation
      @formulario = Formulario.new(
        template: template,
        turma_id: turma_id,
        criado_por: current_user,
        publico_alvo: p_alvo,
        status: status_val,
        data_inicio: data_in,
        data_limite: data_lim
      )

      if @formulario.save
        flash[:notice] = "Formulário criado com sucesso!"
        redirect_to admin_dashboard_path
      else
        @templates = Template.all
        @turmas = Turma.all

        # Exact mapping of validation messages to flash alert to satisfy Cucumber
        alert_msg = @formulario.errors.full_messages.first
        if @formulario.errors[:template_id].any? { |e| e.include?("templates inativos") } || @formulario.errors.full_messages.any? { |m| m.include?("templates inativos") }
          alert_msg = "Não é possível publicar formulários usando templates inativos"
        elsif @formulario.errors[:publico_alvo].any? { |e| e.include?("Obrigatório") }
          alert_msg = "Obrigatório: Selecione se o formulário é destinado a docentes ou discentes."
        elsif @formulario.errors[:publico_alvo].any? { |e| e.include?("muito longo") }
          alert_msg = "Público alvo inválido ou muito longo"
        elsif @formulario.errors.full_messages.any? { |m| m.include?("discentes vinculados") }
          alert_msg = "Ação inválida: Esta turma ainda não possui discentes vinculados no SIGAA para responderem à avaliação."
        elsif @formulario.errors.full_messages.any? { |m| m.include?("Já existe um formulário ativo") }
          alert_msg = "Atenção: Já existe um formulário ativo para os discentes desta turma. Encerre o atual antes de publicar um novo."
        elsif @formulario.errors[:data_inicio].any? || @formulario.errors[:data_limite].any?
          alert_msg = "Datas de início e limite são obrigatórias"
        end

        flash.now[:alert] = alert_msg
        render :new, status: :unprocessable_entity
      end
    else
      # Batch creation from checkbox table (existing logic)
      if params[:turma_ids].blank?
        flash[:alert] = "Selecione pelo menos uma turma para distribuir os formulários."
        redirect_to new_formulario_path and return
      end

      created_count = 0
      errors = []

      ActiveRecord::Base.transaction do
        params[:turma_ids].each do |t_id|
          form = Formulario.new(
            template: template,
            turma_id: t_id,
            criado_por: current_user,
            publico_alvo: p_alvo || template&.perfil_alvo || "discente",
            status: status_val,
            data_inicio: data_in || Time.current,
            data_limite: data_lim || (Time.current + 7.days)
          )
          if form.save
            created_count += 1
          else
            errors << form.errors.full_messages.first
            raise ActiveRecord::Rollback
          end
        end
      end

      if errors.any?
        flash[:alert] = "Erro ao disparar formulários: #{errors.join(', ')}"
        redirect_to new_formulario_path
      else
        flash[:notice] = "Formulário '#{template&.titulo}' disparado para #{created_count} turmas com sucesso!"
        redirect_to admin_dashboard_path
      end
    end
  end
end
