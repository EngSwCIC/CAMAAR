# Controller responsável por gerenciar a redefinição de senhas esquecidas.
class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  # Exibe a tela de solicitação de redefinição de senha.
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Renderiza a view de nova solicitação.
  def new
  end

  # Processa o e-mail informado e envia o link de redefinição.
  #
  # Argumentos: Espera params[:login]
  # Retorno: Nenhum
  # Efeitos Colaterais: Altera o token no BD, enfileira o envio do e-mail.
  def create
    user = User.find_by_login(params[:login])

    if user
      user.generate_reset_token!
      UserMailer.reset_password(user).deliver_later
    end

    redirect_to login_path,
      flash: { success: "Se esse cadastro existir, você receberá um e-mail com o link para redefinir sua senha." }
  end

  # Exibe o formulário de mudança de senha com o token.
  #
  # Argumentos: params[:token]
  # Retorno: Nenhum
  # Efeitos Colaterais: Redireciona se token inválido.
  def edit
    @user = User.find_by(reset_token: params[:token])

    if @user.nil?
      redirect_to login_path, alert: "Link inválido."
    elsif @user.reset_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo link."
    end
  end

  # Efetiva a alteração da senha.
  #
  # Argumentos: params[:token], params[:password], params[:password_confirmation]
  # Retorno: Nenhum
  # Efeitos Colaterais: Altera banco de dados e limpa o token.
  def update
    @user = User.find_by(reset_token: params[:token])
    return if token_invalido_ou_expirado?
    return if senhas_invalidas?

    salvar_nova_senha
  end

  private

  # Verifica a validade do token de redefinição.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Redireciona em caso de erro.
  def token_invalido_ou_expirado?
    if @user.nil? || @user.reset_token_expired?
      redirect_to login_path, alert: "Este link expirou. Solicite um novo link."
      true
    else
      false
    end
  end

  # Valida os campos de senha da requisição.
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Renderiza a tela edit em caso de falha.
  def senhas_invalidas?
    nova_senha  = params[:password]
    confirmacao = params[:password_confirmation]

    if nova_senha.blank? || confirmacao.blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :edit, status: :unprocessable_entity
      return true
    elsif nova_senha != confirmacao
      flash.now[:alert] = "As senhas não coincidem"
      render :edit, status: :unprocessable_entity
      return true
    elsif nova_senha.length < 8
      flash.now[:alert] = "A senha deve ter no mínimo 8 caracteres"
      render :edit, status: :unprocessable_entity
      return true
    end
    false
  end

  # Atualiza os dados no banco de dados e cria a sessão.
  #
  # Argumentos: Nenhum
  # Retorno: Nenhum
  # Efeitos Colaterais: Salva no BD e redireciona página.
  def salvar_nova_senha
    if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
      @user.consume_reset_token!
      session[:user_id] = @user.id
      redirect_to home_path    
    else
      flash.now[:alert] = @user.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end
end