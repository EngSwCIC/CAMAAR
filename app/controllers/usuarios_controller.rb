class UsuariosController < ApplicationController
  def new
    @usuario = Usuario.new
  end

  def create
    @usuario = Usuario.new(usuario_params.merge(role: :estudante))

    if @usuario.save
      redirect_to login_path, notice: "Usuário cadastrado com sucesso."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def usuario_params
    params.require(:usuario).permit(:nome, :email, :password, :password_confirmation)
  end
end
