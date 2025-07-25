# frozen_string_literal: true

# Policy for controlling access to templates.
# Defines who can perform actions on templates.
class TemplatePolicy < ApplicationPolicy
  # Only admins can view the list of templates.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def index?
    user&.admin?
  end

  # Only admins can view a specific template.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def show?
    user&.admin?
  end

  # Only admins can view the new template form.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def new?
    user&.admin?
  end

  # Only admins can create templates.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def create?
    user&.admin?
  end

  # Only admins can view the edit template form.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def edit?
    user&.admin?
  end

  # Only admins can update templates.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def update?
    user&.admin?
  end

  # Only admins can destroy templates.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def destroy?
    user&.admin?
  end

  # Scope class for Template records.
  class Scope < Scope
    # Resolves the scope for templates.
    #
    # ==== Returns
    #
    # * +ActiveRecord::Relation+ - All templates for admins, none for others.
    #
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end
