# frozen_string_literal: true

# Test helper module to bypass authentication
module TestAuthHelper
  def self.included(base)
    base.class_eval do
      include AuthenticationMethods
      include UserFinder
    end
  end

  # Authentication methods for tests
  module AuthenticationMethods
    # rubocop:disable Naming/PredicateMethod
    def skip_authentication_in_tests
      # Skip authentication in tests
      true
    end
    # rubocop:enable Naming/PredicateMethod

    def user_signed_in?
      true
    end

    def current_user
      @current_user ||= find_or_create_test_user
    end

    private

    def authenticate_user!
      skip_authentication_in_tests
    end
  end

  # User finder methods
  module UserFinder
    private

    def find_or_create_test_user
      return @test_user if defined?(@test_user)

      find_existing_admin_user || create_test_admin_user
    end

    def find_existing_admin_user
      User.where(role: :admin).first
    end

    def create_test_admin_user
      User.create!(
        role: :admin,
        email: 'test_admin@example.com',
        matricula: '00000000',
        name: 'Test Admin',
        password: 'password123'
      )
    end
  end
end

# Include in ApplicationController for tests
ApplicationController.include TestAuthHelper if Rails.env.test?
