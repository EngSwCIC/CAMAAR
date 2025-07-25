# Controller para o processo de recuperação de senha.
class RecuperarSenhaController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /recuperar_senha/new
  #
  # Exibe o formulário para o usuário recuperar sua senha.
  #
  def new
    # Formulário para recuperar senha
  end

  # POST /recuperar_senha
  #
  # Processa o formulário de recuperação de senha.
  #
  # ==== Attributes
  #
  # * +matricula+ - A matrícula do usuário.
  # * +email+ - O email do usuário.
  # * +password+ - A nova senha.
  # * +password_confirmation+ - A confirmação da nova senha.
  #
  # ==== Side Effects
  #
  # * Redefine a senha do usuário se os dados estiverem corretos.
  # * Redireciona para a página de login em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create
    # Validações básicas dos parâmetros
    unless params[:matricula].present? && params[:email].present?
      flash.now[:alert] = 'Por favor, preencha todos os campos obrigatórios.'
      render :new, status: :unprocessable_entity
      return
    end

    unless params[:password].present? && params[:password_confirmation].present?
      flash.now[:alert] = 'Por favor, informe a nova senha e sua confirmação.'
      render :new, status: :unprocessable_entity
      return
    end

    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = 'As senhas não coincidem.'
      render :new, status: :unprocessable_entity
      return
    end

    if params[:password].length < 6
      flash.now[:alert] = 'A senha deve ter pelo menos 6 caracteres.'
      render :new, status: :unprocessable_entity
      return
    end

    # Busca usuário por matrícula e email
    user = User.find_by(
      matricula: params[:matricula].strip,
      email: params[:email].strip.downcase
    )

    if user.nil?
      flash.now[:alert] = 'Usuário não encontrado. Verifique sua matrícula e email.'
      render :new, status: :unprocessable_entity
      return
    end

    # Atualiza a senha do usuário
    if user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      flash[:notice] = 'Senha redefinida com sucesso! Agora você pode fazer login.'
      redirect_to new_user_session_path
    else
      flash.now[:alert] = 'Erro ao redefinir senha. Tente novamente.'
      render :new, status: :unprocessable_entity
    end
  end
end
