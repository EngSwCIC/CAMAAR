# frozen_string_literal: true

# Base policy class for Pundit authorization
class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  # Admin-only actions
  def admin_only?
    user&.admin?
  end

  # Professor and above actions
  def professor_and_above?
    user&.admin? || user&.professor? || user&.coordenador?
  end

  # Coordenador and above actions
  def coordenador_and_above?
    user&.admin? || user&.coordenador?
  end

  # Scope class for filtering records
  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
