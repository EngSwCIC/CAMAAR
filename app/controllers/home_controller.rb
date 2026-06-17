class HomeController < ApplicationController
  before_action :require_login
  layout "dashboard"

  def index
    if current_user.discente? || current_user.docente?
      redirect_to formularios_path
    end
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to root_path, alert: "Você precisa estar logado"
    end
  end
end
