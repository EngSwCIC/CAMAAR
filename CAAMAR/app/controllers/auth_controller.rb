class AuthController < ApplicationController
  def login
  end

  def define_password
    @usuario = Usuario.find(params[:id])
  end

  def user_params
    params.permit(:password, :password_confirmation)
  end
  

  def user_params
    params.permit(:password, :password_confirmation)
  end
end
