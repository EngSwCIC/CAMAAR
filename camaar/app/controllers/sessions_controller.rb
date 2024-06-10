
class SessionsController < ApplicationController
  def create
    username = params[:username]
    password = params[:password]

    if username == 'email@aluno.unb.br' && password == 'password'
      redirect_to root_path, notice: 'Welcome, user!'
    else
      flash[:alert] = 'Invalid username or password'
      redirect_to :login
    end
  end
end
