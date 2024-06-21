class PagesController < ApplicationController
  def login
    # Renderiza a view de login
  end

  def home
    # Renderiza a view de home
  end

  def recuperar_senha

  end


  def redefinir_senha
    @usuario = params[:usuario]
    # Renderiza a view de redefinição de senha
  end

  def atualizar_senha
    usuario = params[:usuario]
    new_password = params[:new_password]
    new_password_confirmation = params[:new_password_confirmation]

    if new_password == new_password_confirmation
      user = User.find_by(usuario: usuario)
      if user
        user.update(password: new_password)
        flash[:notice] = "Senha atualizada com sucesso."
        redirect_to login_path
      else
        flash[:alert] = "Usuário não encontrado."
        redirect_to redefinir_senha_path(usuario: usuario)
      end
    else
      flash[:alert] = "As senhas não coincidem."
      redirect_to redefinir_senha_path(usuario: usuario)
    end
  end

  def criar_templete
    # Renderiza a view de criação de templete
  end
end
