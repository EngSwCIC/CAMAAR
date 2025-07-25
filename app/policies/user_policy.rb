# frozen_string_literal: true

# Policy for User authorization.
# Defines who can perform actions on users.
class UserPolicy < ApplicationPolicy
  # Only admins can view the list of users.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def index?
    user&.admin?
  end

  # Admins can view any user profile. Users can view their own profile.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or is viewing their own profile, otherwise false.
  #
  def show?
    user&.admin? || record == user
  end

  # Only admins can create new users.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin, otherwise false.
  #
  def create?
    user&.admin?
  end

  # Admins can update any user. Users can update their own profile.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin or is updating their own profile, otherwise false.
  #
  def update?
    user&.admin? || record == user
  end

  # Admins can destroy any user except themselves.
  #
  # ==== Returns
  #
  # * +Boolean+ - True if the user is an admin and not destroying their own account, otherwise false.
  #
  def destroy?
    user&.admin? && record != user
  end
end
