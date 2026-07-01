# Controller responsável pelo primeiro cadastro de senha via convite.
class PasswordSetsController < ApplicationController
  skip_before_action :require_login 

  # Inicia o processo de definição da senha para novos cadastros.
  #
  # Argumentos: params[:token] da URL.
  # Retorno: Nenhum
  # Efeitos Colaterais: Redireciona caso token seja inválido ou renderiza a tela.
  def new
    @user = User.find_by(invitation_token: params[:token])  
    if @user.nil?
      redirect_to login_path, alert: "Link inválido."
    elsif @user.invitation_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo cadastro."
    end
  end 

  # Efetiva o cadastro processando as senhas enviadas.
  #
  # Argumentos: params[:token], params[:password], params[:password_confirmation]
  # Retorno: Nenhum
  # Efeitos Colaterais: Altera senha no banco de dados e cria sessão.
  def update
    @user = User.find_by(invitation_token: params[:token])  
    return if token_invalido_ou_expirado?
    return if senhas_invalidas?

    efetivar_cadastro
  end

  private

  # Verifica a validade do token.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Redireciona e alerta se for inválido.
  def token_invalido_ou_expirado?
    if @user.nil? || @user.invitation_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo cadastro."
      true
    else
      false
    end
  end

  # Realiza as validações nas senhas fornecidas.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Renderiza nova tentativa em caso de erro.
  def senhas_invalidas?
    nova_senha = params[:password]
    confirmacao = params[:password_confirmation]

    if nova_senha.blank? || confirmacao.blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :new, status: :unprocessable_entity
      return true
    elsif nova_senha != confirmacao
      flash.now[:alert] = "As senhas não coincidem"
      render :new, status: :unprocessable_entity
      return true
    elsif nova_senha.length < 8
      flash.now[:alert] = "A senha deve ter no mínimo 8 caracteres"
      render :new, status: :unprocessable_entity
      return true
    end
    false
  end

  # Salva a nova senha e consome o token de convite.
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Altera o banco de dados, altera sessão e redireciona.
  def efetivar_cadastro
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      @user.consume_invitation_token!
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Cadastro efetivado com sucesso!"
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end
end