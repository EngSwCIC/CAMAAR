class TemplatesController < ApplicationController
  before_action :require_admin

  def index
    @templates = Template.all
    @template = Template.new
  end

  def create
    # Inicializa um novo template com os parâmetros fornecidos
    @template = Template.new(
      titulo: params[:template][:titulo],
      perfil_alvo: params[:template][:perfil_alvo],
      criador: current_user,
      descricao: params[:template][:descricao] || "Template para avaliações de #{params[:template][:perfil_alvo]}"
    )

    if params[:template][:titulo].blank?
      @templates = Template.all
      flash.now[:alert] = "Nome do Template não pode ficar em branco"
      render :index, status: :unprocessable_entity and return
    end

    valid_questions = []
    if params[:template][:perguntas].present?
      params[:template][:perguntas].each do |p_param|
        next if p_param[:texto].blank?
        valid_questions << p_param
      end
    end

    if valid_questions.empty?
      @templates = Template.all
      flash.now[:alert] = "O template deve ter ao menos uma pergunta"
      render :index, status: :unprocessable_entity and return
    end

    @template.skip_questions_validation = true

    ActiveRecord::Base.transaction do
      if @template.save
        valid_questions.each_with_index do |p_param, index|
          QuestaoTemplate.create!(
            template: @template,
            enunciado: p_param[:texto],
            tipo: p_param[:tipo],
            obrigatoria: true,
            ordem: index + 1
          )
        end
        flash[:notice] = "Template criado com sucesso!"
        redirect_to templates_path
      else
        @templates = Template.all
        flash.now[:alert] = "Não foi possível salvar o template."
        render :index, status: :unprocessable_entity
      end
    end
  rescue => e
    @templates = Template.all
    flash.now[:alert] = "Erro ao criar template: #{e.message}"
    render :index, status: :unprocessable_entity
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])
    if @template.update(titulo: params[:template][:titulo], descricao: params[:template][:descricao])
      flash[:notice] = "Template atualizado com sucesso!"
      redirect_to templates_path
    else
      flash.now[:alert] = "Não foi possível atualizar o template."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template = Template.find(params[:id])
    if @template.formularios.exists?
      flash[:alert] = "Não é possível deletar este template pois ele já possui formulários de avaliações vinculados."
    else
      @template.destroy
      flash[:notice] = "Template excluído com sucesso!"
    end
    redirect_to templates_path
  end
end
