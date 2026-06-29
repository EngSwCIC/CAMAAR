require 'capybara/rspec'
require 'selenium/webdriver'
require 'cucumber/rails'

Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :headless_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless! # added on https://github.com/SeleniumHQ/selenium/pull/4762

  Capybara::Selenium::Driver.new app,
    browser: :firefox,
    options: options
end

Capybara.javascript_driver = ENV['GUI'] ? :firefox : :headless_firefox
