# frozen_string_literal: true

# Base policy class for Pundit authorization.
# Defines default permissions and helper methods for other policies.
class ApplicationPolicy
  attr_reader :user, :record

  # Initializes the policy with a user and a record.
  #
  # ==== Attributes
  #
  # * +user+ - The user performing the action.
  # * +record+ - The record being acted upon.
  #
  def initialize(user, record)
    @user = user
    @record = record
  end

  # Determines if the user can view the list of records.
  # Default: false.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns false by default.
  #
  def index?
    false
  end

  # Determines if the user can view a specific record.
  # Default: false.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns false by default.
  #
  def show?
    false
  end

  # Determines if the user can create a new record.
  # Default: false.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns false by default.
  #
  def create?
    false
  end

  # Determines if the user can view the new record form.
  # Delegates to `create?` by default.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns the result of `create?`.
  #
  def new?
    create?
  end

  # Determines if the user can update an existing record.
  # Default: false.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns false by default.
  #
  def update?
    false
  end

  # Determines if the user can view the edit record form.
  # Delegates to `update?` by default.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns the result of `update?`.
  #
  def edit?
    update?
  end

  # Determines if the user can destroy a record.
  # Default: false.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns false by default.
  #
  def destroy?
    false
  end

  # Checks if the user has an admin role.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns true if the user is an admin, otherwise false.
  #
  def admin_only?
    user&.admin?
  end

  # Checks if the user has a professor, coordinator, or admin role.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns true if the user has sufficient privileges, otherwise false.
  #
  def professor_and_above?
    user&.admin? || user&.professor? || user&.coordenador?
  end

  # Checks if the user has a coordinator or admin role.
  #
  # ==== Returns
  #
  # * +Boolean+ - Returns true if the user has sufficient privileges, otherwise false.
  #
  def coordenador_and_above?
    user&.admin? || user&.coordenador?
  end

  # Scope class for filtering records based on user permissions.
  class Scope
    # Initializes the scope with a user and a base scope.
    #
    # ==== Attributes
    #
    # * +user+ - The user for whom to scope the records.
    # * +scope+ - The initial ActiveRecord relation to be scoped.
    #
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    # Resolves the scope, returning the records the user is allowed to see.
    # Must be implemented by subclasses.
    #
    # ==== Returns
    #
    # * +ActiveRecord::Relation+ - The scoped relation.
    #
    # ==== Raises
    #
    # * +NotImplementedError+ - If the subclass does not implement this method.
    #
    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
