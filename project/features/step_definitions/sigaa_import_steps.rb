Dado("que eu acesse a tela de {string}") do |screen_title|
  visit_sigaa_import_screen(screen_title)
end

E("eu acesse a tela de {string}") do |screen_title|
  visit_sigaa_import_screen(screen_title)
end

def visit_sigaa_import_screen(screen_title)
  fazer_login_como(@current_admin)
  visit imports_sigaa_path
  expect(page).to have_content(screen_title)
end

Quando("eu selecionar o periodo letivo desejado") do
  @selected_semester = Sigaa::DataSynchronizer.available_semesters.first
  select @selected_semester, from: "Periodo letivo"
end

Quando("solicitar a sincronizacao de {string}") do |_scope|
  click_button "Sincronizar turmas, materias e participantes"
end

Entao("o sistema deve consultar o SIGAA \\(arquivos no repositorio original)") do
  expect(CourseClass.where(semester: @selected_semester)).to exist
  expect(User.where(role: :participant)).to exist
end

Entao("deve inserir os novos registros identificados") do
  expect(CourseClass.where(semester: @selected_semester).count).to be >= 1
  expect(User.where(role: :participant).count).to be >= 1
end

Entao("deve atualizar os dados dos registros que sofreram alteracoes no SIGAA") do
  expect(page).to have_content(/Sincronizacao concluida\. \d+ novos registros adicionados e \d+ registros atualizados\./)
end

Entao("exibir a mensagem de sincronizacao concluida com novos registros") do
  expect(page).to have_content(/Sincronizacao concluida\. \d+ novos registros adicionados e \d+ registros atualizados\./)
  expect(page).to have_content(/[1-9]\d* novos registros adicionados/)
end

Dado("que todos os dados do SIGAA para o periodo atual ja tenham sido importados previamente") do
  @selected_semester = Sigaa::DataSynchronizer.available_semesters.first
  Sigaa::DataSynchronizer.new(semester: @selected_semester, imported_by: @current_admin).call
end

Quando("eu solicitar a sincronizacao dos dados") do
  select @selected_semester, from: "Periodo letivo"
  click_button "Sincronizar turmas, materias e participantes"
end

Entao("o sistema deve verificar a base de dados") do
  expect(CourseClass.where(semester: @selected_semester)).to exist
end

Entao("constatar que nao ha novos registros para inserir") do
  expect(CourseClass.where(semester: @selected_semester).count).to be >= 1
end

Entao("deve finalizar o processo exibindo a mensagem: {string}") do |message|
  expect(page).to have_content(message)
end
