class Admin::FormulariosController < Admin::BaseController
  def new
    @templates = Template.all
    departamento_admin = current_pessoa.docente&.departamento
    if departamento_admin.present?
      @turmas = Turma.includes(:disciplina, :docente)
                     .joins(:docente)
                     .where(docentes: { departamento: departamento_admin })
    else
      @turmas = Turma.includes(:disciplina, :docente).all 
    end
  end

  def create
    if params[:template_id].blank?
      flash[:alert] = "Obrigatório: O formulário deve ser baseado em um template existente."
      redirect_to new_admin_formulario_path and return
    end

    template = Template.find(params[:template_id])
    
    if template.template_questoes.empty?
      flash[:alert] = "O formulário precisa ter ao menos uma pergunta antes de ser publicado."
      redirect_to new_admin_formulario_path and return
    end

    turmas_ids = params[:turma_ids]

    if turmas_ids.blank?
      flash[:alert] = "Você precisa selecionar pelo menos uma turma."
      redirect_to new_admin_formulario_path and return
    end

    departamento_admin = current_pessoa.docente&.departamento
    if departamento_admin.present?
      turmas_invalidas = Turma.joins(:docente).where(id: turmas_ids).where.not(docentes: { departamento: departamento_admin })
      if turmas_invalidas.any?
        flash[:alert] = "Acesso negado: Você tem permissão para gerenciar apenas as turmas vinculadas ao seu departamento."
        redirect_to admin_root_path and return
      end
    end

    ActiveRecord::Base.transaction do
      turmas_ids.each do |turma_id|
        formulario = Formulario.create!(turma_id: turma_id, template: template, status: :aberto)
        template.template_questoes.each do |tq|
          formulario.questoes.create!(enunciado: tq.enunciado, tipo_resposta: tq.tipo_resposta, opcoes: tq.opcoes)
        end
      end
    end

    redirect_to admin_root_path, notice: "Formulário criado e vinculado às turmas com sucesso."
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Ocorreu um erro ao gerar os formulários: #{e.message}"
    redirect_to new_admin_formulario_path
  end
end