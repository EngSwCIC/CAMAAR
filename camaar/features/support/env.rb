require "cucumber/rails"
require "simplecov"
require "capybara/email"
World(Capybara::Email::DSL)

SimpleCov.start "rails"
ActionController::Base.allow_rescue = false
Cucumber::Rails::Database.javascript_strategy = :truncation

begin
  DatabaseCleaner.strategy = :truncation
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Before do
  DatabaseCleaner.start
end

After do |scenario|
  DatabaseCleaner.clean
end
