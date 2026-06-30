require "simplecov"
SimpleCov.command_name "RSpec"
SimpleCov.start "rails" do
  add_filter "app/controllers/sessions_controller.rb"
  add_filter "app/jobs/"
  add_filter "app/mailers/"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "factory_bot_rails"

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join("test/fixtures") ]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include FactoryBot::Syntax::Methods
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
