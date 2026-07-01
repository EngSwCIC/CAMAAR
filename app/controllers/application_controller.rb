# frozen_string_literal: true

class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  class NotAuthorizedError < StandardError; end

  rescue_from NotAuthorizedError, with: :usuario_nao_autorizado

  helper_method :current_user
  helper_method :current_administrador
  helper_method :policy

  private

  def current_user
    @current_user ||= Usuario.find_by(id: session[:usuario_id])
  end

  def current_administrador
    current_user&.perfil_adm
  end

  def authenticate_user!
    return if current_user.present?

    redirect_to login_path, alert: "Você precisa estar logado para acessar esta página."
  end

  def require_administrador!
    authenticate_user!
    return if performed?
    return if current_user&.administrador?

    redirect_to root_path, alert: "Acesso não autorizado"
  end

  def authorize!(record, query = nil)
    query ||= "#{action_name}?"

    return true if policy(record).public_send(query)

    raise NotAuthorizedError
  end

  def policy(record)
    policy_class_for(record).new(current_user, record)
  end

  def policy_scope(scope)
    policy_class_for(scope).scope(current_user, scope)
  end

  def policy_class_for(record_or_scope)
    model_class =
      if record_or_scope.is_a?(Class)
        record_or_scope
      else
        record_or_scope.class
      end

    "#{model_class.name}Policy".constantize
  end

  def usuario_nao_autorizado
    redirect_back(
      fallback_location: root_path,
      alert: "Você não tem permissão para realizar esta ação."
    )
  end
end
