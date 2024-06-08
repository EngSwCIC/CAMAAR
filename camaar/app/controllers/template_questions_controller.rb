class TemplateQuestionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_admin_data
  before_action :set_template
  layout "admin"

  def index
  end

  def show
    destroy
  end

  def edit
    @template_question = TemplateQuestion.find_by_id(params[:id].to_i)

    save_template_question_data
    get_question_data_from_model
    check_for_commit
  end

  def update
    @errors = []
    body = create_question_body

    if @errors.empty?
      @question = TemplateQuestion.find_by_id(params[:id].to_i)
      if @question.update({
        id: params[:id].to_i,
        title: @title,
        question_type: @question_type,
        body: body,
        template_id: @template.id,
      })
        clear_session
        redirect_to edit_template_path(@template)
      else
        @errors = @question.errors.full_messages
        puts @errors
        render :edit
      end
    end
  end

  def destroy
    question = TemplateQuestion.destroy(params[:id].to_i)

    if question
      redirect_to edit_template_path(@template)
    end
  end

  def new
    save_template_question_data
    check_for_commit
  end

  def create
    @errors = []
    body = create_question_body,
    if @errors.empty?
      @question = TemplateQuestion.new({
        title: @title,
        body: body,
        question_type: @question_type.to_s,
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
    @template = Template.find_by_id(params[:template_id].to_i)
  end

  def create_question_body
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
    else
      body = {}
    end
    return body.to_json
  end

  def save_template_question_data
    session[:title] = params[:title] if params[:title]
    session[:options_number] = params[:options_number] if params[:options_number]
    session[:options] = params[:options] if params[:options]
    session[:question_type] = params[:question_type] if params[:question_type]
    @title = session[:title] || ""
    @options = session[:options] || ["", "", "", "", ""]
    @options_number = session[:options_number]
    @question_type = session[:question_type]
  end

  def get_question_data_from_model
    if not @question_type
      @question_type = @template_question.question_type
    end

    if @question_type == "multiple_choice"
      @options_number = 0
      @options = []
      options = JSON.parse(@template_question.body)["options"]
      options.values.each do |opt|
        @options << opt
        if opt != ""
          @options_number += 1
        end
      end
    end
  end

  def check_for_commit
    case params[:commit]
    when "save"
      update
    when "add"
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
