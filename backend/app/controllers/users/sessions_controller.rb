class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    user = User.find_by(email: params[:session][:user][:email])
    if user && user.valid_password?(params[:session][:user][:password])
      sign_in(:user, user)
      respond_with user
    else
      render json: { message: 'Email ou senha invalidos', authenticated: false, user: user, email: params }, status: :unauthorized
    end
  end

  private

  def respond_with(_resource, _opts = {})
    render json: {
      message: 'Autenticado com sucesso',
      user: current_user,
      authenticated: true
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end

  def log_out_success
    render json: {
      message: 'Sessao encerrada com sucesso'
    }, status: :ok
  end

  def log_out_failure
    render json: {
      message: 'Falha ao encerrar sessao'
    }, status: :internal_server_error
  end
end

