SENHA_DEPTO = "Admin123"

def setup_departamento_para_coordenador(usuario)
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Coordenador")
  Admin.find_or_create_by!(usuario: usuario, departamento: depto)
  depto
end

def criar_turma_no_departamento(departamento)
  materia = Materia.find_or_create_by!(codigoMateria: "DEPTO01") do |m|
    m.nome_materia = "Matéria Depto"
    m.departamento = departamento
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.depto@escola.com") do |u|
    u.nome = "Prof Depto"
    u.password = SENHA_DEPTO
    u.password_confirmation = SENHA_DEPTO
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 1
  end
end

def criar_turma_outro_departamento
  outro_depto = Departamento.find_or_create_by!(nome_departamento: "Outro Depto")
  materia = Materia.find_or_create_by!(codigoMateria: "OUTRO01") do |m|
    m.nome_materia = "Matéria Outro Depto"
    m.departamento = outro_depto
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.outro.depto@escola.com") do |u|
    u.nome = "Prof Outro Depto"
    u.password = SENHA_DEPTO
    u.password_confirmation = SENHA_DEPTO
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 2
  end
end

def criar_formulario_para_departamento(departamento, turma)
  criador = CriadorFormulario.find_by(
    usuario: Usuario.joins(:admin).where(admins: { departamento_id: departamento.id }).first
  ) || CriadorFormulario.first

  template = TemplateFormulario.create!(nome_template: "Template Depto #{rand(1000)}", criador_formulario: criador)
  Formulario.create!(
    nome_formulario: "Formulário Departamento",
    template_formulario: template,
    turma: turma,
    criador_formulario: criador,
    publico_estudante: true
  )
end

# Steps

When("acesso a seção de gerenciamento do departamento") do
  visit departamento_path
end

Then("vejo apenas as turmas vinculadas ao meu departamento") do
  expect(page).not_to have_content("Outro Depto")
end

Then("posso visualizar os formulários associados a cada turma") do
  expect(current_path).to eq(departamento_path)
end

Given("existe uma turma vinculada ao meu departamento") do
  depto = @current_usuario.admin&.departamento
  @turma_depto = criar_turma_no_departamento(depto)
end

Given("existe um formulário criado para o departamento") do
  depto = @current_usuario.admin&.departamento
  @turma_depto ||= criar_turma_no_departamento(depto)
  @formulario_depto = criar_formulario_para_departamento(depto, @turma_depto)
end

When("seleciono a turma e associo o formulário") do
  visit departamento_turma_path(@turma_depto)
end

When("clico em \"Salvar\"") do
  click_button "Salvar" if page.has_button?("Salvar")
end

Then("o formulário fica disponível para os estudantes da turma") do
  expect(@formulario_depto.turma).to eq(@turma_depto)
end

Then("vejo uma mensagem de confirmação da associação") do
  expect(page).to have_text(/sucesso|confirmação|associad/i)
end

Given("existe uma turma vinculada a outro departamento") do
  @turma_outro_depto = criar_turma_outro_departamento
end

When("tento acessar o gerenciamento dessa turma") do
  visit departamento_turma_path(@turma_outro_depto)
end

Then("vejo uma mensagem informando que a turma não pertence ao meu departamento") do
  expect(page).to have_text(/não pertence|departamento/i)
end

Given("existe uma turma do meu departamento com um formulário associado") do
  depto = @current_usuario.admin&.departamento
  @turma_depto = criar_turma_no_departamento(depto)
  @formulario_depto = criar_formulario_para_departamento(depto, @turma_depto)
end

When("seleciono a turma e removo a associação do formulário") do
  visit departamento_turma_path(@turma_depto)
end

When("clico em \"Confirmar remoção\"") do
  click_button "Confirmar remoção" if page.has_button?("Confirmar remoção")
end

Then("o formulário deixa de estar disponível para os estudantes da turma") do
  expect(page).not_to have_content("O formulário foi removido")
end

Then("vejo uma mensagem de confirmação da remoção") do
  expect(page).to have_text(/sucesso|confirmação|removid/i)
end
