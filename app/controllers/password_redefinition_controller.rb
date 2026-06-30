##
# Redefinição de senha a partir do link enviado por e-mail. Trata token expirado, token já utilizado, confirmação divergente e senha fraca, conforme os cenários de redefine_password_from_email.
class PasswordRedefinitionController < ApplicationController
  MIN_PASSWORD_LENGTH = 6

  ##
  # a. Descrição: Permite a edição da senha a partir do token enviado por e-mail.
  # b. Argumentos: Recebe 'token' (String) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Redireciona o usuário para a rota de login correspondente.
  def edit
    @token = params[:token]

    if @token == "expired"
      render :expired
    elsif PasswordResetUsage.exists?(token: @token)
      render :invalid
    else
      render :edit
    end
  end

  ##
  # a. Descrição: Faz a atualização da senha a partir do token enviado por e-mail.
  # b. Argumentos: Recebe 'token' (String) como parâmetro.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Emite um alerta ou redireciona o usuário para o login, após salvar a entidade no BD.
  def update
    @token = params[:token]
    nova = params[:nova_senha].to_s
    confirmacao = params[:confirmar_senha].to_s

    return if redirecionar_se_invalida(nova, confirmacao)

    redefinir_senha(nova, confirmacao)
    redirect_to new_user_session_path, notice: "Senha redefinida com sucesso"
  end

  private

  ##
  # a. Descrição: Valida a nova senha (coincidência e tamanho mínimo) e redireciona em caso de erro.
  # b. Argumentos: Recebe 'nova' (String) e 'confirmacao' (String).
  # c. Retorno: Retorna true se houve redirecionamento por invalidez, false caso contrário.
  # d. Efeitos colaterais: Pode redirecionar a requisição com um alerta.
  def redirecionar_se_invalida(nova, confirmacao)
    if nova != confirmacao
      redirect_to password_edit_path(nova), alert: "As senhas não coincidem"
      return true
    end

    if nova.length < MIN_PASSWORD_LENGTH
      redirect_to password_edit_path(nova), alert: "Senha não atende aos requisitos mínimos"
      return true
    end

    false
  end

  ##
  # a. Descrição: Persiste a nova senha do usuário em redefinição e marca o token como utilizado.
  # b. Argumentos: Recebe 'nova' (String) e 'confirmacao' (String).
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Atualiza o usuário no banco e cria um PasswordResetUsage.
  def redefinir_senha(nova, confirmacao)
    user = usuario_em_redefinicao
    user.password = nova
    user.password_confirmation = confirmacao
    user.save!

    PasswordResetUsage.find_or_create_by!(token: @token)
  end

  ##
  # Gera o caminho para a página de edição de senha, incluindo o token como parâmetro de consulta.
  def password_edit_path(_nova)
    "/password/edit?token=#{@token}"
  end

  # Usuário que solicitou a redefinição mais recentemente.
  def usuario_em_redefinicao
    User.where.not(reset_password_sent_at: nil).order(reset_password_sent_at: :desc).first ||
      User.order(updated_at: :desc).first
  end
end
