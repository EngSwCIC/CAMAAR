# SimpleCov configuration file
SimpleCov.configure do
  # Define the coverage threshold
  minimum_coverage 90
  minimum_coverage_by_file 80
  
  # Refuse to merge results older than 8 hours
  merge_timeout 8 * 3600
  
  # Track files even when they are never loaded
  track_files '{app,lib}/**/*.rb'
  
  # Coverage groups for better organization
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Views', 'app/views'
  add_group 'Helpers', 'app/helpers'
  add_group 'Jobs', 'app/jobs'
  add_group 'Mailers', 'app/mailers'
  add_group 'Policies', 'app/policies'
  add_group 'Services', 'app/services'
  add_group 'Libraries', 'lib'
  
  # Exclude these files from coverage
  add_filter '/vendor/'
  add_filter '/spec/'
  add_filter '/test/'
  add_filter '/features/'
  add_filter '/config/'
  add_filter '/db/'
  add_filter '/bin/'
  add_filter '/script/'
  add_filter '/tmp/'
  add_filter '/log/'
  add_filter '/public/'
  add_filter 'Gemfile'
  add_filter 'Rakefile'
  add_filter 'config.ru'
  
  # Skip these specific files that are typically not testable
  add_filter 'app/channels/application_cable/channel.rb'
  add_filter 'app/channels/application_cable/connection.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  add_filter 'app/models/application_record.rb'
  add_filter 'app/controllers/application_controller.rb' if ENV['SKIP_APPLICATION_CONTROLLER']
end
