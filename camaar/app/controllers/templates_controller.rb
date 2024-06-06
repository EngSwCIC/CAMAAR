require "json"

class TemplatesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_data
  layout "admin"

  def index
    Template.where({ coordinator_id: @coordinator.id })
  end

  def new
    check_for_cancel

    @questions = session[:questions] || {}

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

    if params[:nome_template] && params[:nome_template].gsub(" ", "") != ""
      @nome_template = params[:nome_template]
    end

    session[:nome_template] = @nome_template
    session[:questions] = @questions
  end

  def create
    @template = Template.new(template_params)
    @template.save
    session.delete(:questions)
    session.delete(:nome_template)
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
    @coordinator = Coordinator.find_by({ email: current_admin.email })
    @department = Department.find_by_id(@coordinator.department_id) if @coordinator
  end

  def template_params
    params.require(:template).permit(:nome_template, :questions)
  end

  def check_for_cancel
    puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    if params[:commit] == "cancel"
      session.delete(:questions)
      session.delete(:nome_template)
      redirect_to "/templates"
    end
  end
end
