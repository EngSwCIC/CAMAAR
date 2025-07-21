class ApplicationController < ActionController::Base
  allow_browser versions: :modern  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  helper_method :current_pessoa

  before_action :set_locale
  before_action :require_login, unless: :devise_controller?

  def current_pessoa
    @current_pessoa ||= Pessoa.find_by(email: session[:email])
  end

  private

  def set_locale
    I18n.locale = :pt
  end

  def require_login
    unless current_pessoa
      redirect_to login_path, alert: "Você precisa estar logado para acessar esta página."
    end
  end
end