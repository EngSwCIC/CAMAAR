# Step definitions para features/admin_gerenciar_turmas.feature (#106)

Quando("o sistema carregar a página para o semestre atual") do
  semestre = "2026.1"
  cic = Department.find_or_create_by!(code: "CIC") { |d| d.name = "Departamento de Ciências da Computação" }
  matematica = Department.find_or_create_by!(code: "MAT") { |d| d.name = "Departamento de Matemática" }
  @current_admin.update!(department: cic)

  @turma_cic = CourseClass.create!(code: "CIC001", class_code: "T01", name: "Estrutura de Dados", semester: semestre, department: cic)
  @turma_matematica = CourseClass.create!(code: "MAT001", class_code: "T01", name: "Cálculo 1", semester: semestre, department: matematica)

  visit course_classes_path
end

Então("eu devo visualizar apenas as turmas pertencentes ao {string}") do |_nome_departamento|
  expect(page).to have_content(@turma_cic.name)
end

E("não devo visualizar turmas de outros departamentos \\(como {string})") do |_nome_departamento|
  expect(page).not_to have_content(@turma_matematica.name)
end

E("o sistema deve liberar as opções de avaliação de desempenho para as turmas listadas") do
  expect(page).to have_link("Avaliar desempenho")
end

Dado("que eu tente acessar diretamente o painel da turma {string}, que pertence ao {string}") do |nome_turma, _nome_departamento|
  @current_admin = criar_admin
  cic = Department.find_or_create_by!(code: "CIC") { |d| d.name = "Departamento de Ciências da Computação" }
  @current_admin.update!(department: cic)

  matematica = Department.find_or_create_by!(code: "MAT") { |d| d.name = "Departamento de Matemática" }
  @turma = CourseClass.create!(code: "MAT001", class_code: "T01", name: nome_turma, semester: "2026.1", department: matematica)

  fazer_login_como(@current_admin)
  visit course_class_path(@turma)
end

Quando("o sistema validar minhas permissões de Administrador") do
  # A validação já ocorre no momento da requisição feita no passo anterior.
end

Então("o sistema deve bloquear o meu acesso") do
  expect(page).to have_current_path(course_classes_path)
end

E("deve redirecionar-me para a página inicial de gerenciamento") do
  expect(page).to have_current_path(course_classes_path)
end

E("exibir a mensagem de erro: {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Dado("que o {string} não tenha nenhuma turma ofertada ou ativa no semestre atual") do |_nome_departamento|
  @current_admin = criar_admin
  cic = Department.find_or_create_by!(code: "CIC") { |d| d.name = "Departamento de Ciências da Computação" }
  @current_admin.update!(department: cic)
end

Então("o sistema deve carregar a página sem registros de turmas") do
  expect(page).not_to have_css(".turma")
end

E("deve exibir a mensagem informativa: {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end
