Quando("solicito a atualização dos dados a partir do SIGAA") do
  post "/sigaa/update_database"
end

Então("a base de dados do sistema deve ser atualizada com os novos dados") do
  expect(response).to redirect_to(home_path)
  follow_redirect!
  expect(flash[:notice]).to include("Atualização concluída com sucesso")
end

Então("devo ver uma mensagem de sucesso na atualização") do
  expect(response.body).to include("Atualização concluída com sucesso")
end