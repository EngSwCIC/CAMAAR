# Configuração compartilhada do SimpleCov para RSpec e Cucumber.
# Mantém um único resultado mesclado (merge) das duas suítes em coverage/.resultset.json,
# de modo que cada controller/model seja contabilizado independentemente de qual
# framework (RSpec ou Cucumber) exercita o código.
SimpleCov.start "rails" do
  # Mescla os resultados das duas suítes por até 1h.
  merge_timeout 3600

  # Analisa apenas o código implementado pelo grupo.
  add_filter "/spec/"
  add_filter "/features/"
  add_filter "/config/"
  add_filter "/db/"
  add_filter "/test/"
  add_filter "/vendor/"
  add_filter "/bin/"
  # Classe-base gerada pelo Rails, sem código implementado pelo grupo.
  add_filter "app/jobs/application_job.rb"

  add_group "Controllers", "app/controllers"
  add_group "Models",      "app/models"
  add_group "Services",    "app/services"
  add_group "Mailers",     "app/mailers"
  add_group "Helpers",     "app/helpers"
end
