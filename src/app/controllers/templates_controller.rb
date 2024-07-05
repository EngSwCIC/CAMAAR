class TemplatesController < ApplicationController
  before_action :set_template, only: %i[ show edit update destroy ]

  def index
    if current_user
      @templates = current_user.templates
      render status: :ok
    else
      redirect_to new_user_session_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end

  def show
    @template = Template.find_by(id: params[:id])
  end

  def edit
  end

  def create
    user = User.find_by(id: template_params[:user_id])
    semestre = template_params[:semestre]
    nome = template_params[:nome]
    questoes_ids = template_params[:questoes_ids] || []

    questoes = Questao.where(id: questoes_ids)

    @template = Template.new(user: user, semestre: semestre, nome: nome, questoes: questoes)

    if @template.save
      redirect_to templates_url, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      redirect_to template_url(@template), notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to templates_url, notice: "Template excluído com sucesso."
  end

  private
    def set_template
      @template = Template.find(params[:id])
    end

    def template_params
      params.require(:template).permit(:user_id, :semestre, :nome, questoes_ids: [])
    end
end
