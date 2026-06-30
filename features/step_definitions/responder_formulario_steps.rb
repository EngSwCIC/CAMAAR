SENHA_RESP = "Senha123"

def setup_formulario_para_estudante(estudante_usuario)
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Resposta")
  materia = Materia.find_or_create_by!(codigoMateria: "RESP01") do |m|
    m.nome_materia = "Matéria Resposta"
    m.departamento = depto
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.resp@escola.com") do |u|
    u.nome = "Prof Resposta"
    u.password = SENHA_RESP
    u.password_confirmation = SENHA_RESP
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  turma = Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 1
  end

  admin_u = Usuario.find_or_create_by!(email: "admin.resp@escola.com") do |u|
    u.nome = "Admin Resposta"
    u.password = SENHA_RESP
    u.password_confirmation = SENHA_RESP
    u.role = :admin
  end
  Admin.find_or_create_by!(usuario: admin_u, departamento: depto)
  criador = CriadorFormulario.find_or_create_by!(usuario: admin_u)
  template = TemplateFormulario.create!(nome_template: "Template Resp #{rand(1000)}", criador_formulario: criador)

  Pergunta.create!(
    enunciado: "Como você avalia a disciplina?",
    tipo_pergunta: :discursiva,
    gabarito_discursiva: "Boa",
    template_formulario: template
  )

  formulario = Formulario.create!(
    nome_formulario: "Formulário para Responder",
    template_formulario: template,
    turma: turma,
    criador_formulario: criador,
    publico_estudante: true
  )

  estudante = estudante_usuario.estudante || Estudante.create!(usuario: estudante_usuario)
  Matricula.find_or_create_by!(estudante: estudante, turma: turma) { |m| m.trancado = false }

  { turma: turma, formulario: formulario }
end

# Steps

Given("existe um formulário disponível para minha turma") do
  result = setup_formulario_para_estudante(@current_usuario)
  @formulario_respondivel = result[:formulario]
end

Given("existe um formulário cuja data de encerramento já passou") do
  result = setup_formulario_para_estudante(@current_usuario)
  @formulario_expirado = result[:formulario]
  @formulario_expirado.update!(publico_estudante: false)
end

Given("existe um formulário disponível para uma turma em que não estou matriculado") do
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Outra Turma")
  materia = Materia.find_or_create_by!(codigoMateria: "OUTRA01") do |m|
    m.nome_materia = "Matéria Outra"
    m.departamento = depto
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.outra@escola.com") do |u|
    u.nome = "Prof Outra"
    u.password = SENHA_RESP
    u.password_confirmation = SENHA_RESP
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  turma_outra = Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 9
  end
  admin_u = Usuario.find_or_create_by!(email: "admin.outra@escola.com") do |u|
    u.nome = "Admin Outra"
    u.password = SENHA_RESP
    u.password_confirmation = SENHA_RESP
    u.role = :admin
  end
  Admin.find_or_create_by!(usuario: admin_u, departamento: depto)
  criador = CriadorFormulario.find_or_create_by!(usuario: admin_u)
  template = TemplateFormulario.create!(nome_template: "Template Outra #{rand(1000)}", criador_formulario: criador)
  @formulario_outra_turma = Formulario.create!(
    nome_formulario: "Formulário Outra Turma",
    template_formulario: template,
    turma: turma_outra,
    criador_formulario: criador,
    publico_estudante: true
  )
end

When("acesso o formulário e preencho todas as questões") do
  visit formulario_path(@formulario_respondivel)
  @formulario_respondivel.pergunta_formularios.each do |pf|
    fill_in "respostas[#{pf.id}]", with: "Minha resposta"
  end
end

When("acesso o formulário e deixo questões obrigatórias sem resposta") do
  visit formulario_path(@formulario_respondivel)
end

When("clico em \"Enviar respostas\"") do
  click_button "Enviar respostas"
end

When("tento acessar o formulário") do
  visit formulario_path(@formulario_expirado)
end

When("tento acessar o formulário diretamente pela URL") do
  visit formulario_path(@formulario_outra_turma)
end

Then("minha resposta é registrada no sistema") do
  expect(RespostaFormulario.where(
    formulario: @formulario_respondivel,
    usuario: @current_usuario
  )).to exist
end

Then("vejo uma mensagem de confirmação de envio") do
  expect(page).to have_text(/registrada|sucesso|enviada/i)
end

Then("o sistema não registra a resposta") do
  expect(RespostaFormulario.where(formulario: @formulario_respondivel, usuario: @current_usuario)).not_to exist
end

Then("vejo uma mensagem de erro indicando campos obrigatórios não preenchidos") do
  expect(page).to have_text(/obrigatóri|preencha/i)
end

Then("o sistema não permite o acesso ao formulário") do
  expect(current_path).not_to eq(formulario_path(@formulario_expirado))
end

Then("vejo uma mensagem informando que o prazo de resposta foi encerrado") do
  expect(page).to have_text(/prazo|encerrado|permissão/i)
end

Then("vejo uma mensagem de erro informando que não tenho permissão para responder este formulário") do
  expect(page).to have_text(/permissão/i)
end
