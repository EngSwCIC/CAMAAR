# Controller responsável por gerenciar a sessão dos usuários (login e logout)
class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  # Exibe a página de login
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Renderiza a view de login
  def new
    # renderizar a página de login
  end

  # Autentica o usuário e cria a sessão
  #
  # Argumentos: params[:login], params[:password]
  # Retorno: Nenhum
  # Efeitos Colaterais: Cria sessão, redireciona ou renderiza erro de credenciais.
  def create
    user = User.find_by_login(params[:login])
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path  # tirar o flash[:notice]
    elsif user && user.password_digest.nil? && user.invitation_token.present?
      redirect_to password_set_path(user.invitation_token), notice: "Este é seu primeiro acesso. Por favor, defina uma senha."
    else
      flash.now[:alert] = "Credenciais inválidas"
      render :new, status: :unprocessable_entity
    end
  end

  # Destrói a sessão do usuário (Logout)
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Limpa sessão e redireciona para a tela de login.
  def destroy
    session[:user_id] = nil
    redirect_to login_path, flash: { logout: "Logout realizado com sucesso!" }
  end
end
