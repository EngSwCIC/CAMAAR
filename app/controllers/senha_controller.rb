class SenhaController < ApplicationController
  before_action :require_login, only: [ :redefinir, :atualizar ]

  # GET /senha/redefinir (logged in — change current password)
  def redefinir; end

  # POST /senha/redefinir
  def atualizar
    usuario = current_usuario
    if usuario.authenticate(params[:password])
      if params[:new_password_1] != params[:new_password_2]
        flash.now[:alert] = "As senhas não são as mesmas"
        render :redefinir, status: :unprocessable_entity
        return
      end
      if usuario.update(password: params[:new_password_1], password_confirmation: params[:new_password_2])
        redirect_to senha_redefinir_path, notice: "Senha alterada com sucesso!"
      else
        flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
        render :redefinir, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Senha antiga está incorreta"
      render :redefinir, status: :unprocessable_entity
    end
  end

  # GET /senha/recuperar
  def recuperar; end

  # POST /senha/recuperar — stateless token via generates_token_for (no DB write needed)
  def solicitar
    usuario = Usuario.find_by(email: params[:email].to_s.downcase.strip)
    if usuario
      token = usuario.generate_token_for(:password_reset)
      log_reset_email(usuario, token)
    end
    redirect_to recuperar_senha_path,
      notice: "Se este e-mail estiver cadastrado, você receberá instruções em breve."
  end

  # GET /senha/nova?token=xxx
  def nova
    @token = params[:token]
    unless Usuario.find_by_token_for(:password_reset, @token)
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
    end
  end

  # POST /senha/nova
  def salvar
    @token = params[:token]
    usuario = Usuario.find_by_token_for(:password_reset, @token)
    unless usuario
      redirect_to recuperar_senha_path, alert: "Link de redefinição inválido ou expirado."
      return
    end

    senha = params[:password].to_s
    confirmacao = params[:password_confirmation].to_s

    if senha.blank?
      flash.now[:alert] = "A nova senha é obrigatória."
      return render :nova, status: :unprocessable_entity
    end

    if senha != confirmacao
      flash.now[:alert] = "As duas senhas não são iguais."
      return render :nova, status: :unprocessable_entity
    end

    if usuario.authenticate(senha)
      flash.now[:alert] = "A nova senha deve ser diferente da senha atual."
      return render :nova, status: :unprocessable_entity
    end

    if usuario.update(password: senha, password_confirmation: confirmacao)
      redirect_to login_path, notice: "Senha redefinida com sucesso! Faça login com sua nova senha."
    else
      flash.now[:alert] = usuario.errors[:password].first || usuario.errors.full_messages.first
      render :nova, status: :unprocessable_entity
    end
  end

  private

  def log_reset_email(usuario, token)
    reset_url = "#{request.base_url}/senha/nova?token=#{token}"
    log_dir = Rails.root.join("notificacoes")
    FileUtils.mkdir_p(log_dir)
    log_path = log_dir.join("redefinicao_senha.log")
    content = <<~LOG
      ============================================================
      #{Time.current.strftime('%d/%m/%Y às %H:%M:%S')}
      Para:    #{usuario.email}
      Assunto: Redefinição de senha — CAMAAR

      Olá, #{usuario.nome}!

      Você solicitou a redefinição de senha no sistema CAMAAR.
      Acesse o link abaixo para criar uma nova senha (válido por 48 horas):

        #{reset_url}

      Se você não realizou essa solicitação, ignore este email.

      Atenciosamente,
      Equipe CAMAAR — Universidade de Brasília

    LOG
    File.open(log_path, "a", encoding: "UTF-8") { |f| f.write(content) }
  end
end
