class TemplateController < ApplicationController
  before_action :authenticate_user!

  def show
    user = get_user_from_token
    render json: {
      message: "Logged in",
      user: user,
    }, status: :ok
  end


  # Funcao para decodificar o JWT
  private
  def get_user_from_token
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], 
      ENV['JWT_SECRET_KEY']).first
    user_id = jwt_payload['sub']
    user = User.find(user_id.to_s)
  end
end