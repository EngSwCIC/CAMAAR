# encoding: utf-8

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../config/environment', __FILE__)
require 'cucumber/rails'
require 'capybara/rails'
require 'rspec/mocks'

World(RSpec::Mocks::ExampleMethods)

Before do
  RSpec::Mocks.setup
end

After do
  RSpec::Mocks.verify
  RSpec::Mocks.teardown
end

# Mantém o banco limpo entre cenários
DatabaseCleaner.strategy = :truncation

After do
  # Evita que a sessão/cookies do navegador (Selenium) vazem entre
  # cenários consecutivos marcados com @javascript
  Capybara.reset_sessions!
end

# Capybara usa Selenium para cenários com @javascript
Capybara.default_driver    = :rack_test       # rápido, sem JS
Capybara.javascript_driver = :selenium_chrome_headless  # para @javascript