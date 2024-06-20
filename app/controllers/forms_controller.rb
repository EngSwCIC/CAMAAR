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
    return unless params.permit(:authenticity_token, :commit, :id, :_method, questions: {})

    params[:questions].each do |question_id, answer|
      next if answer.empty?

      # TODO: Get logged in user for creating answer
      question = Question.find(question_id)
      next unless question.valid_answer?(answer)

      Answer.create! answer:, user: logged_user, question: Question.find(question_id)
    end
  end
end
