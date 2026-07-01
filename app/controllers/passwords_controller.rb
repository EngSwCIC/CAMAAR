# Gerencia a definição e redefinição de senha via token enviado por e-mail.
class PasswordsController < ApplicationController
  # Exibe o formulário para definição de nova senha.
  #
  # Parâmetros: +:id+ via params — token de redefinição de senha.
  # Retorno: renderiza o formulário de edição com a +@pessoa+ encontrada.
  # Efeito colateral: redireciona para +login_path+ com alerta se o token
  # for inválido ou não existir no banco.
  def edit
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to login_path, alert: "Link inválido ou expirado."
  end

  # Atualiza a senha da pessoa autenticada pelo token.
  #
  # Parâmetros: +:id+ via params (token); +:pessoa+ com +:password+ e
  # +:password_confirmation+ via params.
  # Retorno: redireciona para +login_path+ com confirmação em caso de
  # sucesso, ou renderiza +:edit+ com alerta se as senhas não coincidirem
  # ou a atualização falhar.
  # Efeito colateral: grava a nova senha (criptografada) e limpa os campos
  # +reset_password_token+ e +reset_password_sent_at+ no banco.
  def update
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
    return rejeitar_senhas_divergentes unless senhas_coincidem?

    if @pessoa.update(password_params)
      @pessoa.update(reset_password_token: nil, reset_password_sent_at: nil)
      redirect_to login_path, notice: "Senha definida com sucesso! Agora você pode acessar o Camaar."
    else
      rejeitar_senhas_divergentes
    end
  end

  private

  # Verifica se os campos de senha e confirmação são idênticos.
  #
  # Retorno: +true+ se coincidem, +false+ caso contrário.
  def senhas_coincidem?
    params[:pessoa][:password] == params[:pessoa][:password_confirmation]
  end

  # Renderiza o formulário de edição com mensagem de erro de senha.
  #
  # Efeito colateral: define +flash.now[:alert]+ e renderiza +:edit+ com
  # status 422.
  def rejeitar_senhas_divergentes
    flash.now[:alert] = "As senhas não coincidem"
    render :edit, status: :unprocessable_entity
  end

  # Filtra os parâmetros permitidos para atualização de senha.
  #
  # Retorno: ActionController::Parameters com +:password+ e
  # +:password_confirmation+.
  def password_params
    params.require(:pessoa).permit(:password, :password_confirmation)
  end
end
