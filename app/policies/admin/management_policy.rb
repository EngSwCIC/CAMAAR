# frozen_string_literal: true

# Policy for Admin Management functionality
module Admin
  class ManagementPolicy < ApplicationPolicy
    def index?
      admin_only?
    end

    def import_users?
      admin_only?
    end

    def import_disciplines?
      admin_only?
    end

    class Scope < Scope
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
