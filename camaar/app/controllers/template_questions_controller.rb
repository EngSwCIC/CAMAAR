class TemplateQuestionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_data
  before_action :set_template
  layout "admin"

  def show
    destroy
  end

  def destroy
    question = TemplateQuestion.destroy(params[:id].to_i)

    if question
      redirect_to edit_template_path(@template)
    end
  end

  def new
    @templates = Template.where(coordinator_id: @coordinator.id)

    params_to_session
    session_to_controller
    check_for_commit
  end

  def create
    @errors = []
    types = { "multiple_choice" => 1, "text" => 2 }
    body = {}

    if @question_type == "multiple_choice"
      body = { "options" => {} }

      @options.each_with_index do |option, index|
        option_number = index + 1
        if option_number <= @options_number.to_i
          if option.empty?
            @errors << "option_#{option_number} Campo não pode estar vazio"
          else
            body["options"][option_number.to_s] = option
          end
        else
          @options[index] = ""
          body["options"][option_number.to_s] = ""
        end
      end
    end

    if @errors.empty?
      @question = TemplateQuestion.new({
        title: @title,
        body: body.to_json,
        question_type: types[params[:question_type]],
        template_id: @template.id,
      })

      if @question.save
        clear_session
        redirect_to edit_template_path(@template)
      else
        @errors = @question.errors.full_messages
        puts @errors
        render :new
      end
    end
  end

  def set_template
    @template = Template.find_by_id(params[:template_id])
  end

  def params_to_session
    session[:title] = params[:title] if params[:title]
    session[:options_number] = params[:options_number] if params[:options_number]
    session[:options] = params[:options] if params[:options]
    session[:question_type] = params[:question_type] if params[:question_type]
  end

  def session_to_controller
    @title = session[:title] || ""
    @options = session[:options] || ["", "", "", "", ""]
    @options_number = session[:options_number] || 1
    @question_type = session[:question_type]
  end

  def check_for_commit
    case params[:commit]
    when "cancel"
      clear_session
      redirect_to edit_template_path(@template)
    when "save"
      create
    when "delete"
      destroy
    end
  end

  def clear_params
    redirect_to new_template_template_question_path(@template)
  end

  def clear_session
    session[:title] = nil
    session[:options_number] = nil
    session[:options] = nil
    session[:question_type] = nil
  end
end
