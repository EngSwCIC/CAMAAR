# Carregado antes de env.rb (ordem alfabética) para instrumentar a cobertura
# antes do Rails ser inicializado. Resultado é mesclado com o do RSpec.
require "simplecov"
SimpleCov.command_name "Cucumber"
SimpleCov.start "rails" do
  add_filter "app/controllers/sessions_controller.rb"
  add_filter "app/jobs/"
  add_filter "app/mailers/"
end
