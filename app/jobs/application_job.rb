# frozen_string_literal: true

# Base class for application jobs.
# Provides a central place to configure job behavior,
# such as retry mechanisms and error handling.
class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
end
