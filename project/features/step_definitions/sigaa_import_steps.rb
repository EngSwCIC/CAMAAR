SCREEN_PATHS = {
  "Importação de Dados do SIGAA" => :imports_sigaa_path,
  "Gerenciamento de Turmas" => :course_classes_path
}.freeze

Dado("que eu acesse a tela de {string}") do |screen_title|
  visit_screen(screen_title)
end

E("eu acesse a tela de {string}") do |screen_title|
  visit_screen(screen_title)
end

Quando("eu acessar a tela de {string}") do |screen_title|
  visit_screen(screen_title)
end

def visit_screen(screen_title)
  @current_admin ||= criar_admin
  fazer_login_como(@current_admin)
  visit send(SCREEN_PATHS.fetch(screen_title))
  expect(page).to have_content(screen_title)
end

Quando("eu selecionar o período letivo desejado") do
  @selected_semester = Sigaa::DataSynchronizer.available_semesters.first
  select @selected_semester, from: "Período letivo"
end

Quando("solicitar a sincronização de {string}") do |_scope|
  click_button "Sincronizar turmas, matérias e participantes"
end

Entao("o sistema deve consultar o SIGAA \\(arquivos no repositório original)") do
  expect(CourseClass.where(semester: @selected_semester)).to exist
  expect(User.where(role: :participant)).to exist
end

Entao("deve inserir os novos registros identificados") do
  expect(CourseClass.where(semester: @selected_semester).count).to be >= 1
  expect(User.where(role: :participant).count).to be >= 1
end

Entao("deve atualizar os dados dos registros que sofreram alterações no SIGAA") do
  expect(page).to have_content(/Sincronização concluída\. \d+ novos registros adicionados e \d+ registros atualizados\./)
end

Entao("exibir a mensagem: {string}") do |message|
  pattern = Regexp.escape(message).gsub("X", '\d+').gsub("Y", '\d+')
  expect(page).to have_content(Regexp.new(pattern))
end

Dado("que todos os dados do SIGAA para o período atual já tenham sido importados previamente") do
  @selected_semester = Sigaa::DataSynchronizer.available_semesters.first
  @current_admin = criar_admin
  Sigaa::DataSynchronizer.new(semester: @selected_semester, imported_by: @current_admin).call
end

Quando("eu solicitar a sincronização dos dados") do
  select @selected_semester, from: "Período letivo"
  click_button "Sincronizar turmas, matérias e participantes"
end

Entao("o sistema deve verificar a base de dados") do
  expect(CourseClass.where(semester: @selected_semester)).to exist
end

Entao("constatar que não há novos registros para inserir") do
  expect(CourseClass.where(semester: @selected_semester).count).to be >= 1
end

Entao("deve finalizar o processo exibindo a mensagem: {string}") do |message|
  expect(page).to have_content(message)
end
