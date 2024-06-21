source "https://rubygems.org"

ruby "3.1.2"

#gems
gem 'bcrypt', '~> 3.1.7'
gem 'csv'
gem 'sqlite3', '~> 1.4', platforms: [:ruby]
gem 'bundler-audit'
gem 'rails', '~> 7.1.3.4'
gem 'sprockets-rails'
gem 'puma', '>= 5.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '>= 4.0.1'
gem 'tzinfo-data', platforms: %i[ windows jruby ]
gem 'bootsnap', require: false
gem 'cucumber'

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'faker'
  gem 'rspec-rails'
  gem 'rails-controller-testing'
  gem 'rubycritic'
  gem 'simplecov', require: false
end

group :development do
  gem 'web-console'
  gem 'rubocop'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'cucumber-rails'
  gem 'database_cleaner'
end
