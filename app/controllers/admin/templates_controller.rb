# app/controllers/admin/templates_controller.rb
class Admin::TemplatesController < ApplicationController
  before_action :require_login
  before_action :require_admin
  before_action :set_template, only: [ :show, :edit, :update, :destroy ]

  def index
    @templates = current_user.templates.order(:name)
  end

  def show
    @responses = @template.template_responses.includes(:user)
  end

  def new
    @template = current_user.templates.build
    @template.template_questions.build
  end

  def create
    @template = current_user.templates.build(template_params)

    if @template.save
      # CORRIGIDO: Redirecionar para a lista de templates
      redirect_to admin_templates_path, notice: "Template criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @template.update(template_params)
      # CORRIGIDO: Redirecionar para a lista de templates
      redirect_to admin_templates_path, notice: "Template atualizado!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
    redirect_to admin_templates_path, notice: "Template removido!"
  end

  private

  def set_template
    @template = current_user.templates.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :description,
      template_questions_attributes: [ :id, :question_text, :question_type, :required, :position, :_destroy, options: [] ])
  end

  def require_admin
    redirect_to user_templates_path unless current_user.admin?
  end
end
