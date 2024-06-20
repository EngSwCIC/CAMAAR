class FormsController < ApplicationController
  include ManagerHelper
  include AuthenticationConcern

  def index
    # TODO: If student, only return forms they can answer
    return redirect_to root_path unless user_authenticated && admin_user?

    @forms = Form.all
  end

  def show
    # TODO: Authenticate: user is admin or has access to this form
    return redirect_to root_path unless user_authenticated

    @form = Form.find(params[:id])
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

      Answer.create! answer:, user: User.first, question: Question.find(question_id)
    end
  end
end
