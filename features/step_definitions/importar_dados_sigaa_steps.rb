
Dado('que os dados do SIGAA estão disponíveis para importação') do
  # Por padrão, o SigaaImporter importará os dados do arquivo JSON enviado, então não é necessário configurar nada aqui.
end

Dado('que os dados do SIGAA foram importados com sucesso') do
  allow(SigaaImporter).to receive(:import_from_files).and_return("importação realizada com sucesso")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'importar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que eu tentei importar os dados do SIGAA mas ocorreu um erro') do
  allow(SigaaImporter).to receive(:import_from_files).and_return("a importação falhou")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'importar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que os dados do SIGAA já existem na base de dados do sistema') do
  allow(SigaaImporter).to receive(:import_from_files).and_return("os dados já existem e não foram duplicados")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'importar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Dado('que alguns dados do SIGAA já existem na base de dados do sistema') do
  allow(SigaaImporter).to receive(:import_from_files).and_return("alguns dados já foram importados e não serão importados novamente")
  arquivo = Rack::Test::UploadedFile.new(Rails.root.join("classes.json"), "application/json")
  page.driver.post(admin_sincronizar_sigaa_path(@admin), { acao: 'importar', arquivo_sigaa: arquivo })
  visit admin_gerenciamento_path(@admin)
end

Então('as turmas, matérias e participantes do SIGAA estão presentes no sistema') do
  expect(page).to have_content('As turmas, matérias e participantes do SIGAA estão presentes no sistema')
end

Então('uma mensagem de erro é exibida informando que a importação falhou') do
  expect(page).to have_content('erro informando que a importação falhou')
end

Então('uma mensagem é exibida informando que os dados já foram importados e não serão importados novamente') do
  expect(page).to have_content('os dados do SIGAA já existem na base de dados do sistema e não serão importados novamente')
end

Então('uma mensagem é exibida informando que alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso') do
  expect(page).to have_content('alguns dados já foram importados e não serão importados novamente, mas os dados restantes serão importados com sucesso')
end
