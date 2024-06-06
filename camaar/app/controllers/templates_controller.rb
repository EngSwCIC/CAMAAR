require "json"

class TemplatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_data
  layout "admin"

  def index
    @templates = Template.where(coordinator_id: @coordinator.id)
  end

  def new
    save_questions_data
    save_draft
    check_for_commit
    clear_params
  end

  def create
    template = Template.new(
      name: @template_name,
      questions: @questions.to_json,
      coordinator_id: @coordinator.id,
    )

    if template.save!
      delete_draft
      redirect_to "/templates"
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def set_admin_data
    @template_name = session[:template_name] || params[:template_name] || ""
    @questions = session[:questions] || params[:questions] || {}
    @coordinator = Coordinator.find_by({ email: current_admin.email })
    @department = Department.find_by_id(@coordinator.department_id) if @coordinator
  end

  def save_draft
    session[:template_name] = @template_name
    session[:questions] = @questions
  end

  def check_for_commit
    case params[:commit]
    when "save"
      create
    when "cancel"
      delete_draft
      redirect_to "/templates"
    end
  end

  def delete_draft
    session.delete(:questions)
    session.delete(:template_name)
  end

  def save_questions_data
    question_index = (@questions.length + 1).to_s
    case params[:opcoes]
    when "multiple_choice"
      @questions[question_index] = {
        "type" => params[:opcoes],
        "title" => "",
        "options" => {},
        "answers" => {},
      }
      params[:escolhas].to_i.times do |n|
        @questions[question_index]["options"][(n + 1).to_s] = ""
        @questions[question_index]["answers"][(n + 1).to_s] = "false"
      end
    when "text"
      @questions[question_index] = {
        "type" => params[:opcoes],
        "title" => "",
        "answer" => "",
      }
    end

    template_name = params[:template_name]
    if template_name && template_name.strip != ""
      @template_name = template_name.strip
    end
  end

  def clear_params
    if !params[:commit] && params[:opcoes]
      redirect_to "/templates/new"
    end
  end
end
