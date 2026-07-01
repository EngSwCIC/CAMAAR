# Gerencia o fluxo de definição de senha inicial para novos usuários.
#
# Novos usuários recebem um email com um link contendo um token único. Este
# controller valida o token, exibe o formulário de definição de senha e persiste
# a nova senha quando as validações são satisfeitas. Após a definição bem-sucedida,
# o token é invalidado para evitar reutilização.
class DefinicaoSenhasController < ApplicationController
  # Exibe o formulário de definição de senha via token enviado por email.
  #
  # @return [void]
  # @note Lê o parâmetro +:token+ da rota. Redireciona para a página raiz com alerta
  #   se o token for inválido ou não corresponder a nenhum usuário.
  def edit
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    return if @usuario.present?

    redirect_to root_path, alert: "Link de definição de senha inválido."
  end

  # Persiste a nova senha para o usuário identificado pelo token.
  #
  # @return [void]
  # @note Lê os parâmetros +:token+, +:senha+ e +:senha_confirmation+.
  #   Redireciona com alerta se o token for inválido, as senhas não conferirem ou a
  #   senha tiver menos de 6 caracteres. Em caso de sucesso, limpa o token e a data
  #   de envio, salva a nova senha no banco de dados e redireciona para a página raiz.
  def update
    @usuario = Usuario.find_by(definicao_senha_token: params[:token])

    return redirecionar_token_invalido unless @usuario.present?
    return render_erro_senha("confirmação não confere") unless senhas_iguais?
    return render_erro_senha("senha inválida") unless senha_valida?

    atribuir_nova_senha

    if @usuario.save
      redirect_to root_path, notice: "Senha definida com sucesso."
    else
      render_erro_senha("senha inválida")
    end
  end

  private

  # Redireciona para a página raiz com mensagem de token inválido.
  #
  # @return [void]
  # @note Efeito colateral: redireciona para +root_path+ com alerta.
  def redirecionar_token_invalido
    redirect_to root_path, alert: "Link de definição de senha inválido."
  end

  # Re-renderiza o formulário de edição com mensagem de erro de senha.
  #
  # @param mensagem [String] detalhe do erro (ex.: "confirmação não confere")
  # @return [void]
  # @note Efeito colateral: define +flash.now[:alert]+ e renderiza +:edit+
  #   com status +422 Unprocessable Content+.
  def render_erro_senha(mensagem)
    flash.now[:alert] = "Falha na definição de senha: #{mensagem}"
    render :edit, status: :unprocessable_content
  end

  # Verifica se os parâmetros +:senha+ e +:senha_confirmation+ são idênticos.
  #
  # @return [Boolean] +true+ se as senhas forem iguais, +false+ caso contrário
  def senhas_iguais?
    params[:senha].to_s == params[:senha_confirmation].to_s
  end

  # Verifica se o parâmetro +:senha+ possui ao menos 6 caracteres.
  #
  # @return [Boolean] +true+ se o comprimento for suficiente, +false+ caso contrário
  def senha_valida?
    params[:senha].to_s.length >= 6
  end

  # Atribui a nova senha e invalida o token de definição no objeto +@usuario+.
  #
  # @return [void]
  # @note Não persiste no banco de dados — o salvamento ocorre no método +update+
  #   que chama este helper.
  def atribuir_nova_senha
    @usuario.senha = params[:senha].to_s
    @usuario.senha_confirmation = params[:senha_confirmation].to_s
    @usuario.definicao_senha_token = nil
    @usuario.definicao_senha_sent_at = nil
  end
end
