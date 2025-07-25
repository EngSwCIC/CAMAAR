# frozen_string_literal: true

# Policy for Formulario authorization.
# Defines who can perform actions on forms.
class FormularioPolicy < ApplicationPolicy
  # Anyone can view the list of forms.
  #
  # ==== Returns
  #
  # * +Boolean+ - Always true.
  #
  def index?
    true
  end

  # Anyone can view a specific form.
  #
  # ==== Returns
  #
  # * +Boolean+ - Always true.
  #
  def show?
    true
  end

  # Only admins and coordinators can create forms.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or coordinator, otherwise false.
  #
  def create?
    user&.admin? || user&.coordenador?
  end

  # Only admins and coordinators can update forms.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or coordinator, otherwise false.
  #
  def update?
    user&.admin? || user&.coordenador?
  end

  # Only admins and coordinators can destroy forms.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or coordinator, otherwise false.
  #
  def destroy?
    user&.admin? || user&.coordenador?
  end
end
