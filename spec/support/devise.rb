# frozen_string_literal: true

RSpec.configure do |config|
  # Include Devise test helpers
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::ControllerHelpers, type: :controller

  # For request specs, we can also use Warden test helpers
  config.include Warden::Test::Helpers, type: :request

  config.before(:suite) do
    Warden.test_mode!
  end

  config.after do
    Warden.test_reset!
  end
end
