class DefinicaoSenhasController < ApplicationController
  def edit
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    return if @usuario.present?

    redirect_to root_path, alert: "Link de definição de senha inválido."
  end

  def update
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    if @usuario.blank?
      redirect_to root_path, alert: "Link de definição de senha inválido."
      return
    end

    nova_senha = params[:senha].to_s
    confirmacao = params[:senha_confirmation].to_s

    if nova_senha != confirmacao
      flash.now[:alert] = "Falha na definição de senha: confirmação não confere"
      render :edit, status: :unprocessable_content
      return
    end

    if nova_senha.length < 6
      flash.now[:alert] = "Falha na definição de senha: senha inválida"
      render :edit, status: :unprocessable_content
      return
    end

    @usuario.senha = nova_senha
    @usuario.senha_confirmation = confirmacao
    @usuario.definicao_senha_token = nil
    @usuario.definicao_senha_sent_at = nil

    if @usuario.save
      redirect_to root_path, notice: "Senha definida com sucesso."
    else
      flash.now[:alert] = "Falha na definição de senha: senha inválida"
      render :edit, status: :unprocessable_content
    end
  end
end
