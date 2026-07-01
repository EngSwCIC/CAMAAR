# Gerencia o fluxo de redefinição de senha para usuários que já possuem conta ativa.
#
# O usuário informa seu email (+new+/+create+), recebe um link por email com token
# único e utiliza esse token para acessar o formulário de nova senha (+edit+/+update+).
# Após a redefinição bem-sucedida, o token é invalidado para evitar reutilização.
class RedefinicaoSenhasController < ApplicationController
  # Exibe o formulário de solicitação de redefinição de senha.
  #
  # @return [void]
  def new
  end

  # Envia o email de redefinição de senha para o endereço informado.
  #
  # @return [void]
  # @note Lê o parâmetro +:email+ do formulário. Redireciona com alerta se o email
  #   estiver em branco ou não corresponder a nenhum usuário. Em caso de sucesso, dispara
  #   o envio do email de redefinição e redireciona para a página raiz.
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

  # Exibe o formulário de redefinição de senha via token enviado por email.
  #
  # @return [void]
  # @note Lê o parâmetro +:token+ da rota. Redireciona para a página raiz com alerta
  #   se o token for inválido ou não corresponder a nenhum usuário.
  def edit
    @usuario = Usuario.find_by(redefinicao_senha_token: params[:token])

    return if @usuario.present?

    redirect_to root_path, alert: "Link de redefinição de senha inválido."
  end

  # Persiste a nova senha para o usuário identificado pelo token de redefinição.
  #
  # @return [void]
  # @note Lê os parâmetros +:token+, +:senha+ e +:senha_confirmation+.
  #   Redireciona com alerta se o token for inválido, as senhas não conferirem ou a
  #   senha tiver menos de 6 caracteres. Em caso de sucesso, limpa o token e a data
  #   de envio, salva a nova senha no banco de dados e redireciona para a página raiz.
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
