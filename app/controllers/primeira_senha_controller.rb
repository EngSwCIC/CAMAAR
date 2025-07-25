# Controller para o processo de definição da primeira senha de um usuário.
class PrimeiraSenhaController < ApplicationController
  skip_before_action :authenticate_user!

  # GET /primeira_senha/new
  #
  # Exibe o formulário para o usuário definir sua primeira senha.
  #
  def new
    # Formulário para definir primeira senha
  end

  # POST /primeira_senha
  #
  # Processa o formulário de definição da primeira senha.
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
  # * Define a primeira senha do usuário se os dados estiverem corretos.
  # * Redireciona para a página de login em caso de sucesso.
  # * Renderiza o formulário novamente em caso de falha.
  #
  def create # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    # Validações básicas dos parâmetros
    unless params[:matricula].present? && params[:email].present?
      flash.now[:alert] = 'Por favor, preencha todos os campos obrigatórios.'
      render :new, status: :unprocessable_entity
      return
    end

    unless params[:password].present? && params[:password_confirmation].present?
      flash.now[:alert] = 'Por favor, informe a senha e sua confirmação.'
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

    unless user.sem_senha?
      flash.now[:alert] = 'Este usuário já possui uma senha definida. Use a opção "Esqueci minha senha" se necessário.'
      render :new, status: :unprocessable_entity
      return
    end

    if user.definir_primeira_senha(params[:password], params[:password_confirmation])
      flash[:notice] = 'Senha definida com sucesso! Agora você pode fazer login.'
      redirect_to new_user_session_path
    else
      flash.now[:alert] = 'Erro ao definir senha. Tente novamente.'
      render :new, status: :unprocessable_entity
    end
  end
end
