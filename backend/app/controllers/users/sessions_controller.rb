class Users::SessionsController < Devise::SessionsController
  respond_to :json
  private
  def respond_with(_resource, _opts = {})
    render json: {
      message: 'Autenticado com sucesso',
      user: current_user,
    }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_user

    log_out_failure
  end
  def log_out_success
    render json: {
      message: 'Sessao encerrada com sucesso',
    }, status: :ok

  end
  def log_out_failure
    render json: {
      message: 'Falha ao encerrar sessao'
    }, status: :internal_server_error
  end
end