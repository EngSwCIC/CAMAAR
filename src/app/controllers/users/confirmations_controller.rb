
# Controladora responsável pelo reenvio do e-mail de definição de senha.
class Users::ConfirmationsController < DeviseController

  # Cria uma instância do usuário para armazenar eventuais erros.
  # Metodo Http GET /users/confirmations/new
  def new
    self.resource = resource_class.new
  end

  # Manda as instruções de definição de senha para o email preenchido e redireciona para a página de login se ocorrer tudo bem.
  # Recebe o email para o qual deve ser enviado como argumento.
  # Se não for bem sucedido, permanece na página e mostra o erro.
  # Metodo Http POST /users/confirmations
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    if successfully_sent?(resource)
      respond_with resource, location: new_session_path(resource)
    else
      respond_with(resource)
    end
  end
end