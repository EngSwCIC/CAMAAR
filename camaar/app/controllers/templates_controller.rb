require "json"

class TemplatesController < ApplicationController
  before_action :set_admin_data
  before_action :get_admin_templates
  before_action :set_template_data, only: [:destroy, :edit, :update, :show]
  before_action :check_for_commit
  layout "admin"

  def index
    @templates = Template.where({ coordinator_id: @coordinator.id })
  end

  def new
    template = Template.create({ coordinator_id: @coordinator.id })
    redirect_to edit_template_path(template)
  end

  def create
  end

  def show
    @templates = Template.where(coordinator_id: @coordinator.id)
    check_for_commit
  end

  def edit
  end

  def update
    @errors = []
    save_template_data

    if @questions.any?
      template = @template.update(
        name: @template_name,
        draft: false,
      )

      if template
        redirect_to templates_path
      end
    else
      flash[:alert] = "O template precisa conter pelo menos uma pergunta"

      # render :edit
      redirect_to edit_template_path(@template)
    end
  end

  def destroy
    template = @template.destroy

    if template
      redirect_to templates_path
    end
  end

  def check_for_commit
    case params[:commit]
    when "delete"
      destroy
    end
  end

  def save_template_data
    @template_name = params[:template][:name] if not params[:template][:name].empty?
  end

  def get_admin_templates
    @templates = Template.where(coordinator_id: @coordinator.id)
    if @templates.empty?
      @errors << "Não foram encontrados templates"
    end
  end

  def set_template_data
    @templates = Template.where(coordinator_id: @coordinator.id)

    @template = Template.find_by_id(params[:id])
    if @template
      @template_name = params[:name] || @template.name
      @questions = TemplateQuestion.where({ template_id: @template.id })
    else
      flash[:alert] = "Não foi possível encontrar o template."
      redirect_to templates_path
    end
  end
end
