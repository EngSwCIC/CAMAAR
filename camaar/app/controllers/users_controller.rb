class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      case params[:user][:type]
      when "Aluno"
        @aluno = Aluno.create(user_params.except(:type))
      when "Administrador"
        @administrador = Administrador.create(user_params.except(:type))
      end
    else
      flash[:alert] = "Por favor, preencha todos os campos obrigatórios."
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:nome, :senha, :type)
  end
end
