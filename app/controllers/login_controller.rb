class LoginController < ApplicationController
  def index; end

  def create
    usuario = Usuario.find_by(email: params[:email].to_s.downcase.strip)
    if usuario&.authenticate(params[:password])
      session[:usuario_id] = usuario.id
      redirect_to home_por_papel(usuario), notice: "Login realizado com sucesso!"
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:usuario_id)
    redirect_to login_path, notice: "Você saiu da conta."
  end

  private
  def home_por_papel(usuario)
    case usuario.role
    when "admin"     then gerenciamento_path
    when "professor" then relatorios_path
    when "estudante" then avaliacoes_path
    else root_path
    end
  end
end
