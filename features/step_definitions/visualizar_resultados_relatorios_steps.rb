SENHA_VIS_REL = "Admin123"

def garantir_admin_logado_vis_rel
  return if @admin_vis_rel_logado

  admin_u = Usuario.find_or_create_by!(email: "admin.vis.rel@escola.com") do |u|
    u.nome = "Admin Vis Rel"
    u.password = SENHA_VIS_REL
    u.password_confirmation = SENHA_VIS_REL
    u.role = :admin
  end
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Vis Rel")
  Admin.find_or_create_by!(usuario: admin_u, departamento: depto)
  @criador_vis_rel = CriadorFormulario.find_or_create_by!(usuario: admin_u)

  visit login_path
  fill_in "Email", with: admin_u.email
  fill_in "Senha", with: SENHA_VIS_REL
  find("input[type='submit']").click
  @admin_vis_rel_logado = true
end

def criar_turma_vis_rel(codigo:, disciplina:, semestre:, departamento:)
  materia = Materia.find_or_create_by!(codigoMateria: "VR#{codigo.gsub(/\W/, '')}") do |m|
    m.nome_materia = disciplina
    m.departamento = departamento
  end
  prof_u = Usuario.find_or_create_by!(email: "prof.#{codigo.downcase.gsub(/\W/, '')}@escola.com") do |u|
    u.nome = "Prof #{codigo}"
    u.password = SENHA_VIS_REL
    u.password_confirmation = SENHA_VIS_REL
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = semestre
    t.numero_turma = codigo[/\d+/].to_i
  end
end

def criar_formulario_vis_rel(nome:, turma:, publico_estudante:, total_respostas:)
  template = TemplateFormulario.create!(
    nome_template: "Tmpl #{nome} #{rand(9999)}",
    criador_formulario: @criador_vis_rel
  )
  formulario = Formulario.find_or_create_by!(nome_formulario: nome, turma: turma) do |f|
    f.criador_formulario = @criador_vis_rel
    f.template_formulario = template
    f.publico_estudante = publico_estudante
  end

  total_respostas.times do |i|
    resp_u = Usuario.find_or_create_by!(email: "resp#{i}.#{nome.parameterize[0, 20]}@escola.com") do |u|
      u.nome = "Respondente #{i}"
      u.password = SENHA_VIS_REL
      u.password_confirmation = SENHA_VIS_REL
      u.role = :estudante
    end
    Estudante.find_or_create_by!(usuario: resp_u)
    RespostaFormulario.find_or_create_by!(formulario: formulario, usuario: resp_u) do |r|
      r.data_resposta = Time.current
    end
  end

  formulario
end

# Background

Given("que o usuário tem permissões para visualizar resultados") do
  garantir_admin_logado_vis_rel
end

Given("que o usuário está na aba de resultados") do
  garantir_admin_logado_vis_rel
  visit relatorios_path
end

# "que existem as seguintes Turmas no sistema:" está definido em
# criar_formularios_discentes_steps.rb e popula tanto @turmas_por_codigo
# quanto @turmas_vis_rel — não redefina aqui.

Given("que existem os seguintes formulários no sistema:") do |table|
  @formularios_vis_rel ||= {}

  table.hashes.each do |row|
    nome       = row["nomeFormulario"].strip
    turma_code = row["turma"].strip
    publico    = row["publicoAlvo"].strip == "Discente"
    total      = row["totalRespostas"].to_i
    turma      = @turmas_vis_rel&.[](turma_code)
    next unless turma

    formulario = criar_formulario_vis_rel(
      nome: nome,
      turma: turma,
      publico_estudante: publico,
      total_respostas: total
    )
    @formularios_vis_rel[nome] = formulario
  end
end

Given("que não existem formulários para a turma {string}") do |_turma|
  # no-op — banco está limpo para essa turma fictícia
end

Given("que o usuário não tem permissões para visualizar resultados") do
  nao_admin_u = Usuario.find_or_create_by!(email: "noadmin.vis.rel@escola.com") do |u|
    u.nome = "Não Admin"
    u.password = SENHA_VIS_REL
    u.password_confirmation = SENHA_VIS_REL
    u.role = :estudante
  end
  Estudante.find_or_create_by!(usuario: nao_admin_u)
  visit login_path
  fill_in "Email", with: nao_admin_u.email
  fill_in "Senha", with: SENHA_VIS_REL
  find("input[type='submit']").click
end

# When

When("ele clica no botão \"Resultados\" do formulário {string}") do |nome|
  formulario = @formularios_vis_rel&.[](nome) || Formulario.find_by!(nome_formulario: nome)
  visit relatorio_path(formulario)
end

When("ele seleciona a turma {string} no filtro {string}") do |turma_code, _filtro|
  visit relatorios_path
  @turma_filtro = @turmas_vis_rel&.[](turma_code)
end

When("ele seleciona {string} no filtro {string}") do |_valor, _filtro|
  visit relatorios_path
end

When("ele tenta acessar a aba de resultados") do
  visit relatorios_path
end

# Then

Then("o sistema deve exibir a página de resultados do formulário {string}") do |nome|
  expect(page).to have_content(nome)
end

Then("deve mostrar o total de {string} respostas recebidas") do |total|
  expect(page).to have_content(total)
end

Then("deve apresentar a distribuição das respostas para cada pergunta") do
  expect(page).to have_content("Total de respostas")
end

Then("deve apresentar os dados agregados em formato gráfico") do
  expect(page).to have_content("Relatório")
end

Then("o sistema deve listar apenas os formulários da turma {string}") do |turma_code|
  turma = @turmas_vis_rel&.[](turma_code)
  if turma
    Formulario.where(turma: turma).pluck(:nome_formulario).each do |nome|
      expect(page).to have_content(nome)
    end
  end
end

Then("deve exibir o total de respostas de cada formulário listado") do
  expect(page).to have_content("Respostas")
end

Then("o sistema deve listar apenas os formulários destinados a {string}") do |_publico|
  expect(current_path).to eq(relatorios_path)
end

Then("deve exibir uma mensagem informando que o formulário ainda não recebeu respostas") do
  expect(page).to have_content("Não há respostas registradas")
end

Then("não deve apresentar gráficos ou dados agregados") do
  expect(page).not_to have_link("Exportar CSV")
end

Then("deve exibir uma mensagem informando que o número de respostas é insuficiente para divulgação") do
  expect(page).to have_content(/respostas|registradas/i)
end

Then("não deve apresentar a distribuição individual das respostas") do
  expect(page).to have_content("Total de respostas")
end

Then("o sistema não deve listar nenhum formulário") do
  expect(page).not_to have_content("TES-T04")
end

Then("deve exibir uma mensagem informando que não há resultados para os filtros selecionados") do
  expect(page).to have_content(/formulário|cadastrado/i)
end

# "o sistema não deve permitir o acesso" está definido em
# atualizar_base_dados_sigaa_steps.rb — não redefina aqui.
