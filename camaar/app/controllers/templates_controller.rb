require "json"

class TemplatesController < ApplicationController
  before_action :authenticate_admin!, :set_admin_data
  before_action :set_template_data, only: [:destroy, :edit, :show]
  layout "admin"

  def index
    @templates = Template.where(coordinator_id: @coordinator.id)
  end

  def new
    template = Template.create({ coordinator_id: @coordinator.id })
    redirect_to edit_template_path(template)
  end

  def create
  end

  def show
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
      @errors << "O template precisa conter pelo menos uma pergunta"
      render :edit
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
    when "save"
      update
    when "delete"
      destroy
    end
  end

  def save_template_data
    @template_name = params[:template][:name] if not params[:template][:name].empty?
  end

  def set_template_data
    @template = Template.find_by_id(params[:id])
    @template_name = params[:name] || @template.name
    @questions = TemplateQuestion.where({ template_id: @template.id })
  end
end
