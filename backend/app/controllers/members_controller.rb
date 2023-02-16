class MembersController < ApplicationController
  def index
    @members = if params[:id].present?
      cclass = Cclass.find(params[:id])
      cclass.members
    else
      Member.all
    end
    render json: @members, status: :ok
  end

  def show
    @member = Member.find(params[:id])
    render json: @member, status: :ok
  end

  ##
  #
  # Metodo survey_answered
  #
  # Responsavel por salvar que um questionario específico foi respondido por um usuario.
  #
  # Parametros: survey_id = id do questionário respondido
  #
  # Retorno: json
  #
  def survey_answered
    survey_id = params[:survey_id]
    @survey = Survey.find(survey_id)
    
    @current_user = MembersController.get_user_from_token
    @member = Member.find(@current_user.member_id)
    if @member.answered_surveys.exists?(survey_id)
      render json: {
        message: 'Questionário já respondido'
      }, status: :bad_request
    else
      @member.answered_surveys << @survey
      render json: {
        message: 'Respostas do questionário salvas'
      }, status: :ok
    end
  end

  # Funcao para decodificar o JWT
  def self.get_user_from_token
    puts request.headers['Authorization']
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], 
      ENV['JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    User.find(user_id.to_s)
  end
end
