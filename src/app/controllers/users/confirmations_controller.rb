
# Controladora responsável pelo reenvio do e-mail de definição de senha.
class Users::ConfirmationsController < DeviseController

  ##
  # Metodo Http GET /users/confirmations/new
  # Cria uma instância do usuário para armazenar eventuais erros.
  def new
    self.resource = resource_class.new
  end

  ##
  # POST /resource/confirmation
  # Envia instruções de redefinição de senha como confirmação
  #
  # +param+ [Hash] resource_params - Os parâmetros do usuário necessários para enviar as instruções de redefinição de senha, obtidos dos parâmetros permitidos
  # +effect_side+ Envia instruções de redefinição de senha para o e-mail fornecido. Redireciona para uma página apropriada se bem-sucedido, ou renderiza o formulário novamente em caso de falha
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with resource, location: new_session_path(resource)
    else
      respond_with(resource)
    end
  end
end