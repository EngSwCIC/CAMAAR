# frozen_string_literal: true

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Removed manual FactoryBot.find_definitions hook; factory_bot_rails auto-loads factories
end
