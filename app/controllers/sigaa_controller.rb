class SigaaController < ApplicationController
  before_action :authenticate_user!

  def update_database
    resultado = SigaaSyncService.new(current_user).call

    if resultado[:success]
      flash[:notice] = resultado[:message]
    else
      flash[:alert] = resultado[:message]
    end

    redirect_to home_path
  end
end