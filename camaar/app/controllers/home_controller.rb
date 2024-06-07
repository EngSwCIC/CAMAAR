class HomeController < ApplicationController
  before_action :logout, only: :index

  def index; end

  private
  def logout
    if admin_signed_in?
      sign_out(current_admin)  # Faz logout do usuário
    elsif user_signed_in?
      sign_out(current_user)
    end
  end
end
