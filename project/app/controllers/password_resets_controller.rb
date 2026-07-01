##
# Conduz a solicitação e a aplicação de uma nova senha por meio de token temporário.
class PasswordResetsController < ApplicationController
  layout "auth"

  # Mensagem neutra que evita revelar se um endereço está cadastrado.
  GENERIC_MESSAGE = "Se o email estiver cadastrado, você receberá instruções para redefinir sua senha"

  ##
  # Exibe o formulário de solicitação de redefinição de senha.
  #
  # Não recebe argumentos.
  #
  # Retorna a resposta HTML construída pelo Rails.
  #
  # Efeitos colaterais: renderiza a view de solicitação.
  def new
  end

  ##
  # Solicita a redefinição para o e-mail informado.
  #
  # Não recebe argumentos explícitos; utiliza +params[:password_reset]+.
  #
  # Retorna uma resposta de redirecionamento para o formulário de solicitação.
  #
  # Efeitos colaterais: consulta o usuário, grava um token, envia e-mail quando o
  # endereço existe e define uma mensagem neutra de confirmação.
  def create
    user = User.find_by(email: reset_request_params[:email].to_s.strip.downcase)
    UserMailer.password_reset(user, user.generate_password_reset_token!).deliver_now if user

    redirect_to new_password_reset_path, notice: GENERIC_MESSAGE
  end

  ##
  # Exibe o formulário de nova senha para um token válido.
  #
  # Não recebe argumentos explícitos; utiliza +params[:token]+.
  #
  # Retorna a resposta HTML ou uma resposta +404 Not Found+ para token inválido.
  #
  # Efeitos colaterais: consulta o usuário e pode renderizar a página de token inválido.
  def edit
    load_user
    render_invalid_token unless @user
  end

  ##
  # Aplica a nova senha associada ao token de redefinição.
  #
  # Não recebe argumentos explícitos; utiliza o token da rota e os parâmetros de senha.
  #
  # Retorna um redirecionamento ao login, uma resposta de validação ou uma resposta +404+.
  #
  # Efeitos colaterais: atualiza a senha e remove tokens ou renderiza erros de confirmação.
  def update
    load_user
    return render_invalid_token unless @user
    return render_password_mismatch unless passwords_match?

    apply_password_reset
  end

  private

  ##
  # Carrega o usuário associado ao token de redefinição atual.
  #
  # Não recebe argumentos explícitos; utiliza +params[:token]+.
  #
  # Retorna o User encontrado ou +nil+ para token inválido ou expirado.
  #
  # Efeitos colaterais: consulta o banco e define +@token+ e +@user+.
  def load_user
    @token = params[:token]
    @user = User.find_by_reset_token(@token)
  end

  ##
  # Filtra o e-mail aceito na solicitação de redefinição.
  #
  # Não recebe argumentos explícitos; lê +params[:password_reset]+.
  #
  # Retorna ActionController::Parameters contendo apenas +email+.
  #
  # Efeitos colaterais: pode lançar ActionController::ParameterMissing.
  def reset_request_params
    params.require(:password_reset).permit(:email)
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
    flash.now[:alert] = "Link de redefinição de senha inválido ou expirado"
    render :invalid, status: :not_found
  end

  def passwords_match?
    password_params[:password] == password_params[:password_confirmation]
  end

  def render_password_mismatch
    flash.now[:alert] = "Confirmação de senha não confere"
    render :edit, status: :unprocessable_entity
  end

  def apply_password_reset
    @user.apply_new_password!(password_params[:password])
    redirect_to login_path, notice: "Senha redefinida com sucesso"
  end
end
