class RedefinicaoSenhasController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.strip

    if email.blank?
      redirect_to redefinir_senha_path, alert: "Falha na redefinição de senha: informe seu email"
      return
    end

    usuario = Usuario.find_by(email: email)

    if usuario.blank?
      redirect_to redefinir_senha_path, alert: "Falha na redefinição de senha: usuário não encontrado"
      return
    end

    usuario.enviar_email_redefinicao_senha!
    redirect_to root_path, notice: "Solicitação de redefinição de senha enviada."
  end

  def edit
    @usuario = Usuario.find_by(redefinicao_senha_token: params[:token])

    return if @usuario.present?

    redirect_to root_path, alert: "Link de redefinição de senha inválido."
  end

  def update
    @usuario = Usuario.find_by(redefinicao_senha_token: params[:token])

    if @usuario.blank?
      redirect_to root_path, alert: "Link de redefinição de senha inválido."
      return
    end

    nova_senha = params[:senha].to_s
    confirmacao = params[:senha_confirmation].to_s

    if nova_senha != confirmacao
      flash.now[:alert] = "Falha na redefinição de senha: confirmação não confere"
      render :edit, status: :unprocessable_content
      return
    end

    if nova_senha.length < 6
      flash.now[:alert] = "Falha na redefinição de senha: senha inválida"
      render :edit, status: :unprocessable_content
      return
    end

    @usuario.senha = nova_senha
    @usuario.senha_confirmation = confirmacao
    @usuario.redefinicao_senha_token = nil
    @usuario.redefinicao_senha_sent_at = nil

    if @usuario.save
      redirect_to root_path, notice: "Senha redefinida com sucesso."
    else
      flash.now[:alert] = "Falha na redefinição de senha: senha inválida"
      render :edit, status: :unprocessable_content
    end
  end
end
