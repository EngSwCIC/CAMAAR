require 'capybara/cucumber'
require 'capybara/dsl'
require 'rspec/expectations'
require 'selenium-webdriver'

Capybara.configure do |config|
  config.default_driver      = :selenium_chrome_headless
  config.default_max_wait_time = 5
  config.app_host            = ENV.fetch('APP_HOST', 'http://localhost:3000')
  config.ignore_hidden_elements = true
end

Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless=new')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--window-size=1280,900')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

World(Capybara::DSL)
World(RSpec::Matchers)
