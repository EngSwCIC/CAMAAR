class PagesController < ApplicationController
  def login
    # Renderiza a view de login
  end

  def home
    # Renderiza a view de home
  end

  def recuperar_senha
    @username = params[:username]
  end


  def update_password
    @user = User.find_by(usuario: params[:username])

    if @user.present? && params[:new_password] == params[:new_password_confirmation]
      if @user.update(senha: params[:new_password])
        redirect_to login_path, notice: 'Senha alterada com sucesso.'
      else
        flash.now[:alert] = 'Houve um problema ao alterar sua senha. Por favor, tente novamente.'
        render :recuperar_senha
      end
    else
      flash.now[:alert] = 'As senhas não coincidem ou usuário não encontrado.'
      render :recuperar_senha
    end
  end


  def criar_templete
    # Renderiza a view de criação de templete
  end
end
