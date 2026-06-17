class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to is_admin? ? admin_root_path : avaliacoes_path
    end
  end

  def create
    pessoa = Pessoa.find_by(email: params[:login]) || Pessoa.find_by(usuario: params[:login])
    if pessoa && pessoa.authenticate(params[:password])
      session[:pessoa_id] = pessoa.usuario
      if pessoa.admin?
        redirect_to admin_root_path
      else
        redirect_to avaliacoes_path
      end
    else
      flash.now[:alert] = "Identificação ou senha inválidos. Verifique suas credenciais e tente novamente."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:pessoa_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end
end