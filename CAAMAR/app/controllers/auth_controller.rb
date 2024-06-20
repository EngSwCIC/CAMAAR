class AuthController < ApplicationController
  def login
  end

  def define_password
    
    @usuario = Usuario.find(params[:id])
    # print(@user)
    # if @user.update(user_params)
    #   redirect_to root_path, notice: 'Senha atualizada!'
    # else
    #   render :define_password
    # end
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
