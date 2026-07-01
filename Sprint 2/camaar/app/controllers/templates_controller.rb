class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_template, only: %i[ show edit update destroy ]
  layout 'authenticated'

  def index
    @templates = Template.all
  end

  def show
  end

  def new
    @template = Template.new
    @template.questoes.build
  end

  def edit
  end

  def create
    @template = Template.new(template_params)
    if @template.save
      redirect_to templates_path, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @template.destroy
      redirect_to templates_path, notice: "Template removido."
    else
      redirect_to templates_path, alert: @template.errors.full_messages.to_sentence
    end
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:titulo, questoes_attributes: [:id, :enunciado, :_destroy])
  end
end