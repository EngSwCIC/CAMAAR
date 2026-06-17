class Admin::BaseController < ApplicationController
  layout 'admin'
  
  before_action :require_login
  before_action :require_admin

  private

  def require_admin
    unless is_admin?
      redirect_to root_path, alert: "Acesso negado. Apenas administradores podem gerar este relatório."
    end
  end
end