# frozen_string_literal: true

# Policy for the Curso model.
# Defines who can perform actions on courses.
class CursoPolicy < ApplicationPolicy
  # Anyone can view the list of courses.
  #
  # ==== Returns
  #
  # * +Boolean+ - Always true.
  #
  def index?
    true
  end

  # Anyone can view a specific course.
  #
  # ==== Returns
  #
  # * +Boolean+ - Always true.
  #
  def show?
    true
  end

  # Only admins and coordinators can create courses.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or coordinator, otherwise false.
  #
  def create?
    user&.admin? || user&.coordenador?
  end

  # Only admins and coordinators can update courses.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or coordinator, otherwise false.
  #
  def update?
    user&.admin? || user&.coordenador?
  end

  # Only admins can destroy courses.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def destroy?
    user&.admin?
  end

  # Scope class for Curso records.
  class Scope < Scope
    # Resolves the scope for courses.
    #
    # ==== Returns
    #
    # * +ActiveRecord::Relation+ - All courses are visible to everyone.
    #
    def resolve
      scope.all
    end
  end
end
