# Reutilizar o gerenciamento de paginas dos outros steps

Dado('que os dados do SIGAA foram atualizados com sucesso') do
  allow(SigaaImporter).to receive(:update_from_files).and_return("atualização realizada com sucesso")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'atualizar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que eu tentei atualizar os dados do SIGAA mas ocorreu um erro') do
  allow(SigaaImporter).to receive(:update_from_files).and_return("falha")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'atualizar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que os dados do SIGAA já estão atualizados na base de dados do sistema') do
  allow(SigaaImporter).to receive(:update_from_files).and_return("os dados do SIGAA já estão atualizados e não serão atualizados novamente")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'atualizar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que alguns dados do SIGAA já estão atualizados na base de dados do sistema') do
  allow(SigaaImporter).to receive(:update_from_files).and_return("alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'atualizar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Então('as turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA') do
  expect(page).to have_content('As turmas, matérias e participantes do SIGAA estão atualizados no sistema com os dados atuais do SIGAA.')
end

Então('uma mensagem de erro é exibida informando que a atualização falhou') do
  expect(page).to have_content('erro informando que a atualização falhou')
end

Então('uma mensagem é exibida informando que os dados já estão atualizados e não serão atualizados novamente') do
  expect(page).to have_content('os dados do SIGAA já estão atualizados e não serão atualizados novamente')
end

Então('uma mensagem é exibida informando que alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso') do
  expect(page).to have_content('alguns dados já estão atualizados e não serão atualizados novamente, mas os dados restantes serão atualizados com sucesso')
end
