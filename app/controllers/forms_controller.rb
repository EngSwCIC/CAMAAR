class FormsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def index
    # TODO: If student, only return forms they can answer
    return redirect_to root_path unless user_authenticated && admin_user?

    @forms = Form.all
  end

  def show
    form = Form.find(params[:id])
    return redirect_to root_path unless user_authenticated && user_belongs_to?(form.discipline)

    @answers = {}
    @form = form
    @form.questions.each do |question|
      @answers[question.id] = (Answer.where user_id: logged_user.id, question_id: question.id).first
    end
  end

  def create
    Rails.logger.debug("Received: #{params[:questions].inspect}")
  end

  def update
    params.permit(:authenticity_token, :commit, :id, :_method, questions: {})
    return redirect_to root_path unless user_authenticated && user_belongs_to?(Form.find(params[:id]).discipline)

    questions = params[:questions].reject { |_, v| v == '' }
    questions.each do |question_id, answer|
      question = Question.find(question_id)
      next unless question.valid_answer?(answer)

      Answer.create! answer:, user: logged_user, question:
    end

    flash[:success] = 'Formulário respondido com sucesso' unless questions.empty?
    redirect_to evaluations_path
  end
end
