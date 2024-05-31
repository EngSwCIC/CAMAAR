Given('I have answered a form from {string}') do |string|
  Given %{I am on the Avaliacoes page}
  When %{I press "#{string}"}
  And %{I should be on the answer form page}
  And %{I select "sim" from "radio?"}
  And %{I fill in "texto?" with "texto!"}
  And %{I press "Enviar"}
end