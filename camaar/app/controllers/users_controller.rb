class UsersController < ApplicationController
  # def login
  #   user = User.find_by(email: login_params[:email])
  #   if user.valid_password?(login_params[:password])
  #       render json: user, status: :ok
  #   else
  #       head :unauthorized
  #   end
  # rescue StandardError => e
  #     head :unauthorized
  # end
  #
  def index
      users = User.all
      render json: array_serializer(users), status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  def show
      user = User.find(params[:id])
      render json: serializer(user), status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  def create
      user = User.new(user_params)
      puts user_params
      user.save!
      render json: user, status: :created
  rescue StandardError => e
      render json: e, status: :unprocessable_entity
  end

  def update
      user = User.find(params[:id])
      user.update!(user_params)
      render json: user, status: :ok
  rescue StandardError => e
      render json: e, status: :bad_request
  end

  def delete
      user = User.find(params[:id])
      user.destroy!
      render json: user, status: :ok
  rescue StandardError => e
      render json: e, status: :not_found
  end

  private

  # def login_params
  #     params.require(:user).permit(:email, :password)
  # end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :curso, :matricula, :formacao, :ocupacao)
  end

  def serializer(user)
    UserSerializer.new.serialize_to_json(user)
  end

  def array_serializer(users)
    Panko::ArraySerializer.new(users, each_serializer: UserSerializer).to_json
  end
end
