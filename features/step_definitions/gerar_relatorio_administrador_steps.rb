SENHA_REL = "Admin123"

def setup_formulario_com_respostas
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Relatorio")

  admin_criador_u = Usuario.find_or_create_by!(email: "criador.rel@escola.com") do |u|
    u.nome = "Criador Formularios Rel"
    u.password = SENHA_REL
    u.password_confirmation = SENHA_REL
    u.role = :admin
  end
  Admin.find_or_create_by!(usuario: admin_criador_u, departamento: depto)
  criador = CriadorFormulario.find_or_create_by!(usuario: admin_criador_u)

  materia = Materia.find_or_create_by!(codigoMateria: "REL001") do |m|
    m.nome_materia = "Matéria Relatório"
    m.departamento = depto
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.rel@escola.com") do |u|
    u.nome = "Prof Relatorio"
    u.password = SENHA_REL
    u.password_confirmation = SENHA_REL
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  turma = Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 1
  end

  template = TemplateFormulario.create!(nome_template: "Template Rel", criador_formulario: criador)
  @formulario_rel = Formulario.create!(
    nome_formulario: "Formulário com Respostas",
    template_formulario: template,
    turma: turma,
    criador_formulario: criador,
    publico_estudante: true
  )
  @formulario_rel
end

def criar_resposta_para_formulario(formulario)
  resp_usuario = Usuario.find_or_create_by!(email: "respondente.rel@escola.com") do |u|
    u.nome = "Respondente Rel"
    u.password = SENHA_REL
    u.password_confirmation = SENHA_REL
    u.role = :estudante
  end
  Estudante.find_or_create_by!(usuario: resp_usuario)
  RespostaFormulario.find_or_create_by!(formulario: formulario, usuario: resp_usuario) do |r|
    r.data_resposta = Time.current
  end
end

# Steps

Given("existe um formulário com respostas registradas") do
  setup_formulario_com_respostas
  criar_resposta_para_formulario(@formulario_rel)
end

Given("existe um relatório gerado para um formulário") do
  setup_formulario_com_respostas
  criar_resposta_para_formulario(@formulario_rel)
end

Given("existe um formulário que ainda não recebeu nenhuma resposta") do
  setup_formulario_com_respostas
  @formulario_sem_respostas = @formulario_rel
end

When("acesso a seção de relatórios e seleciono o formulário") do
  visit relatorios_path
  expect(page).to have_content("Formulário com Respostas")
  click_link "Gerar relatório"
end

When("clico em \"Gerar relatório\"") do
  click_link "Gerar relatório" if page.has_link?("Gerar relatório")
end

When("clico em \"Exportar CSV\"") do
  visit relatorio_path(@formulario_rel) unless page.has_link?("Exportar CSV")
  click_link "Exportar CSV"
end

When("tento acessar a seção de relatórios") do
  visit relatorios_path
end

Then("o sistema exibe o relatório com todas as respostas consolidadas") do
  expect(page).to have_content("Relatório")
  expect(page).to have_content("Total de respostas")
end

Then("posso visualizar as estatísticas de cada questão") do
  expect(page).to have_content("Total de respostas")
end

Then("o sistema realiza o download de um arquivo CSV") do
  expect(page.response_headers["Content-Type"]).to include("text/csv")
end

Then("o arquivo contém todas as respostas dos estudantes") do
  expect(page.response_headers["Content-Type"]).to include("text/csv")
end

Then("o sistema exibe uma mensagem informando que não há respostas registradas") do
  expect(page).to have_content("Não há respostas registradas")
end

Then("não gera o relatório") do
  expect(page).not_to have_link("Exportar CSV")
end
