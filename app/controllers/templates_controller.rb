class TemplatesController < ApplicationController
  before_action :require_login
  before_action :require_admin

  def index
    @templates = current_user.templates.order(created_at: :desc)
  end

  private

  def require_admin
    return if admin?

    redirect_to discente_dashboard_path, alert: "Você não tem permissão para acessar esta página"
  end
end
