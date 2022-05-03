class SurveyAnswersController < ApplicationController
  # before_action :authenticate_user!

  def create
    # @current_user = get_user_from_token
    # @member = Member.find(@current_user.member_id)
    # Usa id = 1 para membro pra teste de protótipo
    @member = Member.find(1)

    head :unprocessable_entity and return if @member.blank?
      
    @survey_answer = SurveyAnswer.new(survey_answer_params)
    @survey_answer.member = @member

    if @survey_answer.save!
      render json: @survey_answer, include: [:answers => {include: :likert_answers}]
    else
      head :unprocessable_entity
    end
  end

  private

  # Funcao para decodificar o JWT
  def get_user_from_token
    puts request.headers['Authorization']
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], 
      ENV['JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    user = User.find(user_id.to_s)
  end

  def survey_answer_params
    params.require(:survey_answer)
            .permit(
              :survey_id,
              :cclass_id,
              answers_attributes: [
                :survey_question_id,
                :content,
                :question_type,
                likert_answers_attributes: [:likert_question_id, :content]
              ]
            )
  end
end
