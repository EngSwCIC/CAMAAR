Given('I have answered a form from {string}') do |string|
  steps %{Given I am on the Avaliacoes page}
  steps %{When I press "#{string}"}
  steps %{And I should be on the answer form page}
  steps %{And I select "sim" from "radio?"}
  steps %{And I fill in "texto?" with "texto!"}
  steps %{And I press "Enviar"}
end