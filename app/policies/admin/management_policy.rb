# frozen_string_literal: true

# Policy for Admin Management functionality
module Admin
  # Defines the authorization policy for the admin management dashboard.
  class ManagementPolicy < ApplicationPolicy
    # Determines if the user can access the main management page.
    #
    # ==== Returns
    #
    # * +Boolean+ - True if the user is an admin, otherwise false.
    #
    def index?
      admin_only?
    end

    # Determines if the user can import users.
    #
    # ==== Returns
    #
    # * +Boolean+ - True if the user is an admin, otherwise false.
    #
    def import_users?
      admin_only?
    end

    # Determines if the user can import disciplines.
    #
    # ==== Returns
    #
    # * +Boolean+ - True if the user is an admin, otherwise false.
    #
    def import_disciplines?
      admin_only?
    end

    # Scope class for management-related records.
    class Scope < Scope
      # Resolves the scope for management records.
      #
      # ==== Returns
      #
      # * +ActiveRecord::Relation+ - All records for admins, none for others.
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
end
