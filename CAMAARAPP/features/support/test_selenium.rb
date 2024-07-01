require 'selenium-webdriver'
require 'webdrivers'

# Register the driver and browser
driver = Selenium::WebDriver.for :firefox

begin
  driver.navigate.to "http://example.com"
  puts driver.title # Should output "Example Domain"
ensure
  driver.quit
end