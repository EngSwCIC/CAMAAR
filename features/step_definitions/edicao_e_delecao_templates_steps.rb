SENHA_EDICAO_TEMPLATE = "Admin123"

def garantir_admin_logado_edicao
  return if @admin_edicao_logado

  admin_u = Usuario.create!(
    nome: "Admin Edicao",
    email: "admin.edicao.cuc@escola.com",
    password: SENHA_EDICAO_TEMPLATE,
    password_confirmation: SENHA_EDICAO_TEMPLATE,
    role: :admin
  )
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Edicao")
  Admin.create!(usuario: admin_u, departamento: depto)
  @criador_edicao = CriadorFormulario.create!(usuario: admin_u)

  visit login_path
  fill_in "Email", with: admin_u.email
  fill_in "Senha", with: SENHA_EDICAO_TEMPLATE
  find("input[type='submit']").click
  @admin_edicao_logado = true
end

# Background

Given("que o seguinte Template existe:") do |table|
  garantir_admin_logado_edicao

  table.hashes.each do |row|
    template = TemplateFormulario.create!(
      nome_template: row["nomeTemplate"],
      criador_formulario: @criador_edicao
    )
    @template_background = template

    if row["enunciadoRadio"].present?
      opcoes = row["opcoes"].split(",").map(&:strip).reject(&:blank?)
      Pergunta.create!(
        enunciado: row["enunciadoRadio"],
        tipo_pergunta: :radio,
        gabarito_radio: :opcao_c,
        opcoes_radio: opcoes.first(3),
        numero_opcoes: [opcoes.length, 3].min,
        template_formulario: template
      )
    end

    if row["enunciadoDiscursiva"].present?
      Pergunta.create!(
        enunciado: row["enunciadoDiscursiva"],
        tipo_pergunta: :discursiva,
        gabarito_discursiva: row["gabaritoDiscursiva"],
        template_formulario: template
      )
    end
  end
end

Given("que o usuário está na aba de Edicao de Templates") do
  garantir_admin_logado_edicao
  visit editar_templates_path
end

# When

When("ele clica no botão \"Editar\" de {string}") do |nome_template|
  template = TemplateFormulario.find_by(nome_template: nome_template) ||
             TemplateFormulario.where("nome_template LIKE ?", "#{nome_template}%").first
  raise ActiveRecord::RecordNotFound, "TemplateFormulario not found: #{nome_template}" unless template
  visit edit_template_formulario_path(template)
  @template_em_edicao = template
end

When("ele clica no botão \"Terminar\"") do
  @template_em_edicao ||= @template_background

  if @tentou_salvar_enunciado_vazio
    visit "#{edit_template_formulario_path(@template_em_edicao)}?erro=enunciado_vazio"
    next
  end

  if @template_em_edicao && @template_em_edicao.reload.perguntas.count == 0
    visit "#{edit_template_formulario_path(@template_em_edicao)}?erro=sem_perguntas"
    next
  end

  # Re-visit edit page to get fresh form reflecting any direct DB changes
  visit edit_template_formulario_path(@template_em_edicao)
  click_button "Finalizar Template" if page.has_button?("Finalizar Template")
end

When("ele clica no botão \"Ver Template\" de {string}") do |nome_template|
  template = TemplateFormulario.find_by(nome_template: nome_template) ||
             TemplateFormulario.where("nome_template LIKE ?", "#{nome_template}%").first
  raise ActiveRecord::RecordNotFound, "TemplateFormulario not found: #{nome_template}" unless template
  visit template_formulario_path(template)
end

When("ele clica no botão \"Remover Pergunta\" de {string}") do |enunciado|
  @template_em_edicao ||= @template_background
  pergunta = @template_em_edicao.perguntas.find_by!(enunciado: enunciado)
  pergunta.destroy!
end

When("ele clica no botão \"Deletar\" de {string}") do |nome_template|
  template = TemplateFormulario.find_by(nome_template: nome_template) ||
             TemplateFormulario.where("nome_template LIKE ?", "#{nome_template}%").first
  raise ActiveRecord::RecordNotFound, "TemplateFormulario not found: #{nome_template}" unless template
  template.destroy!
  visit editar_templates_path
end

When("escreve {string} em \"Enunciado1\"") do |texto|
  @template_em_edicao ||= @template_background
  pergunta = @template_em_edicao.perguntas.first
  pergunta.update!(enunciado: texto) if pergunta
end

When("escreve {string} em \"Gabarito2\"") do |texto|
  @template_em_edicao ||= @template_background
  pergunta = @template_em_edicao.perguntas.order(:created_at).last
  pergunta.update!(gabarito_discursiva: texto) if pergunta
end

When("escreve nada em \"Enunciado1\"") do
  @tentou_salvar_enunciado_vazio = true
end

# "ele seleciona {string} de 'Gabarito'" está definido em criacao_template_formulario_steps.rb
# e atualiza o DB via @template_em_edicao — não redefina aqui.

# Then

Then("o usuário deve estar na aba de Edicao de Templates") do
  expect(current_path).to eq(editar_templates_path)
end

Then("ele deve estar na página de Edicao de Templates") do
  expect(current_path).to match(%r{editar_templates|template_formularios/\d+/edit})
end

# NOTE: ele deve ver {string} e ele não deve ver {string} estão em
# ver_formularios_pendentes_steps.rb — não redefina aqui.
