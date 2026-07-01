##
# Permite que um usuário importado defina sua primeira senha por token temporário.
class PasswordSetupsController < ApplicationController
  layout "auth"

  before_action :load_user

  ##
  # Exibe o formulário de definição inicial de senha.
  #
  # Não recebe argumentos explícitos; utiliza o usuário carregado pelo token da rota.
  #
  # Retorna a resposta HTML ou uma resposta +404 Not Found+ para token inválido.
  #
  # Efeitos colaterais: pode renderizar a página de token inválido.
  def edit
    render_invalid_token unless @user
  end

  ##
  # Define a primeira senha do usuário associado ao token.
  #
  # Não recebe argumentos explícitos; utiliza o token da rota e os parâmetros de senha.
  #
  # Retorna um redirecionamento ao login, uma resposta de validação ou uma resposta +404+.
  #
  # Efeitos colaterais: atualiza a senha e remove tokens ou renderiza erros de confirmação.
  def update
    return render_invalid_token unless @user

    if password_params[:password] != password_params[:password_confirmation]
      flash.now[:alert] = "Confirmação de senha não confere"
      render :edit, status: :unprocessable_entity
    else
      @user.apply_new_password!(password_params[:password])
      redirect_to login_path, notice: "Senha definida com sucesso"
    end
  end

  private

  ##
  # Carrega o usuário associado ao token de definição inicial.
  #
  # Não recebe argumentos explícitos; utiliza +params[:token]+.
  #
  # Retorna o User encontrado ou +nil+ para token inválido ou expirado.
  #
  # Efeitos colaterais: consulta o banco e define +@token+ e +@user+.
  def load_user
    @token = params[:token]
    @user = User.find_by_setup_token(@token)
  end

  ##
  # Filtra a senha e sua confirmação.
  #
  # Não recebe argumentos explícitos; lê +params[:user]+.
  #
  # Retorna ActionController::Parameters com +password+ e +password_confirmation+.
  #
  # Efeitos colaterais: pode lançar ActionController::ParameterMissing.
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  ##
  # Renderiza a resposta usada para tokens inválidos ou expirados.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML com status +404 Not Found+.
  #
  # Efeitos colaterais: define uma mensagem de alerta e renderiza a view +invalid+.
  def render_invalid_token
    flash.now[:alert] = "Link de definição de senha inválido ou expirado"
    render :invalid, status: :not_found
  end
end
