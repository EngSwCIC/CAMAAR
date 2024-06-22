class TemplateQuestionsController < ApplicationController
  before_action :set_admin_data
  before_action :set_template
  before_action :set_template_question, only: [:edit, :update, :destroy]
  before_action :check_for_commit
  layout "admin"

  def index
  end

  def show
  end

  def edit
    get_question_data_from_model
    save_to_session
    save_to_controller
  end

  def update
    @errors = []
    get_question_data_from_model
    save_to_session
    save_to_controller

    new_data = {
      id: params[:id].to_i,
      title: @title,
      question_type: @question_type,
      body: create_question_body,
      template_id: @template.id,
    }

    if @template_question.update(new_data) and @errors.empty?
      clear_session
      redirect_to edit_template_path(@template)
    else
      @errors.concat @template_question.errors.full_messages
      flash[:alert] = @errors
      redirect_to edit_template_template_question_path(@template, @template_question)
    end
  end

  def destroy
    if @template_question.destroy
      clear_session
      redirect_to edit_template_path(@template)
    end
  end

  def new
    save_to_session
    save_to_controller
  end

  def create
    save_to_session
    save_to_controller
    @errors = []

    @question = TemplateQuestion.new({
      title: @title,
      body: create_question_body,
      question_type: @question_type,
      template_id: @template.id,
    })

    if @question.save and @errors.empty?
      clear_session
      redirect_to edit_template_path(@template)
    else
      @errors.concat @question.errors.full_messages

      flash[:alert] = @errors

      save_to_session
      redirect_to new_template_template_question_path
    end
  end

  def set_template
    @template = Template.find_by_id(params[:template_id].to_i)
  end

  def set_template_question
    @template_question = TemplateQuestion.find_by_id(params[:id].to_i)
  end

  def create_question_body
    body = { "options" => {} }

    if @question_type == "multiple_choice"
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

    return body.to_json
  end

  def save_to_session
    if not params[:template_question]
      session[:title] = params[:title] if params[:title]
      session[:options_number] = params[:options_number] if params[:options_number]
      session[:options] = params[:options] if params[:options]
      session[:question_type] = params[:question_type] if params[:question_type]
    else
      session[:title] = params[:template_question][:title] if params[:template_question][:title]
      session[:options_number] = params[:template_question][:options_number] if params[:template_question][:options_number]
      session[:options] = params[:options] if params[:options]
      session[:question_type] = params[:template_question][:question_type] if params[:template_question][:question_type]
    end
  end

  def save_to_controller
    @title = session[:title] || ""
    @options = session[:options] || ["", "", "", "", ""]
    @options_number = session[:options_number]
    @question_type = session[:question_type]
  end

  def get_question_data_from_model
    session[:question_type] = @template_question.question_type
    session[:title] = @template_question.title
    session[:options_number] = 0
    session[:options] = []

    options = JSON.parse(@template_question.body)["options"]
    if options.empty?
      session[:options] = ["", "", "", "", ""]
    else
      options.values.each_with_index do |opt, i|
        session[:options][i] = opt
        if session[:options][i] != ""
          session[:options_number] += 1
        end
      end
    end
  end

  def check_for_commit
    case params[:commit]
    when "cancel"
      clear_session
      redirect_to edit_template_path(@template)
    when "delete"
      destroy
    end
  end

  def clear_session
    session[:title] = nil
    session[:options_number] = nil
    session[:options] = nil
    session[:question_type] = nil
  end
end
