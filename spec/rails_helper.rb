require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'shoulda/matchers'

Rails.application.config.active_support.deprecation = :raise

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort(e.message)
end

RSpec.configure do |config|

  config.fixture_path = ["#{::Rails.root}/spec/fixtures"]

  config.use_transactional_fixtures = true

  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
    DatabaseCleaner.strategy = :truncation
  end

  config.include FactoryBot::Syntax::Methods
  
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :system) do
    driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.include Devise::Test::ControllerHelpers, type: :controller
end