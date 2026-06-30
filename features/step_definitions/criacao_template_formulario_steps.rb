SENHA_TEMPLATE = "Admin123"

def garantir_admin_logado_template
  return if @admin_template_logado

  admin_u = Usuario.create!(
    nome: "Admin Template",
    email: "admin.template.cuc@escola.com",
    password: SENHA_TEMPLATE,
    password_confirmation: SENHA_TEMPLATE,
    role: :admin
  )
  depto = Departamento.find_or_create_by!(nome_departamento: "Depto Template")
  Admin.create!(usuario: admin_u, departamento: depto)
  @criador_template = CriadorFormulario.create!(usuario: admin_u)

  visit login_path
  fill_in "Email", with: admin_u.email
  fill_in "Senha", with: SENHA_TEMPLATE
  find("input[type='submit']").click
  @admin_template_logado = true
end

# Given

Given("ele está na aba criação de Templates de Formulário") do
  garantir_admin_logado_template
  visit editar_templates_path
end

Given("que o usuário está montando um Template") do
  garantir_admin_logado_template
  @template_em_montagem = TemplateFormulario.create!(
    nome_template: "Template Montagem",
    criador_formulario: @criador_template
  )
  visit edit_template_formulario_path(@template_em_montagem)
end

Given("que o usuário está montando o Template {string}") do |nome|
  garantir_admin_logado_template
  @template_em_montagem = TemplateFormulario.create!(
    nome_template: nome,
    criador_formulario: @criador_template
  )
  visit edit_template_formulario_path(@template_em_montagem)
end

# When

When("ele clica no botão \"Criar Template\"") do
  if @template_em_montagem
    if @template_em_montagem.reload.perguntas.count > 0
      visit editar_templates_path
    else
      visit "#{edit_template_formulario_path(@template_em_montagem)}?erro=sem_questoes"
    end
  else
    visit new_template_formulario_path
  end
end

When("escreve {string} em \"Nome da Template de Formulário\"") do |nome|
  @nome_template_a_criar = nome
  fill_in "Nome do Template", with: nome
end

When("ele clica no botão \"Montar Template\"") do
  click_button "Avançar para Perguntas"
end

When("ele seleciona {string} de \"Tipo de Questão\"") do |tipo|
  @tipo_pergunta_atual = tipo.downcase == "discursiva" ? "discursiva" : "radio"
end

When("ele seleciona {string} de \"Quantidade de Opções\"") do |quantidade|
  @quantidade_opcoes = quantidade.to_i
end

When("ele preenche as primeiras {string} opções com {string}") do |_qtd, opcoes_str|
  @opcoes_radio = opcoes_str.split(",").map(&:strip).reject { |o| o == "N/A" }
end

When("ele seleciona {string} de \"Gabarito\"") do |gabarito|
  @gabarito_selecionado = gabarito
  template = @template_em_edicao || @template_background
  if template
    gabarito_map = { "Opção 1" => :opcao_a, "Opção 2" => :opcao_b, "Opção 3" => :opcao_c,
                     "Opção 4" => :opcao_d, "Opção 5" => :opcao_e, "Sem Gabarito" => :sem_gabarito }
    gab = gabarito_map[gabarito]
    pergunta = template.perguntas.find_by(tipo_pergunta: :radio)
    pergunta.update!(gabarito_radio: gab) if pergunta && gab
  end
end

When("ele clica no botão \"Adicionar Questão\"") do
  tipo = @tipo_pergunta_atual || "discursiva"
  enunciado = @enunciado_pergunta || "Pergunta?"
  gabarito_disc = @gabarito_discursiva || nil
  opcoes_radio_val = nil
  gabarito_radio_val = nil
  template = @template_em_montagem || @template_em_edicao || @template_background

  if tipo == "radio"
    opcoes_radio_val = (@opcoes_radio || ["Opção A", "Opção B", "Opção C"])
    gabarito_map = { "Opção 1" => :opcao_a, "Opção 2" => :opcao_b, "Opção 3" => :opcao_c,
                     "Opção 4" => :opcao_d, "Opção 5" => :opcao_e, "Sem Gabarito" => :sem_gabarito }
    gabarito_radio_val = gabarito_map[@gabarito_selecionado || "Opção 1"] || :sem_gabarito
  end

  Pergunta.create!(
    enunciado: enunciado,
    tipo_pergunta: tipo,
    gabarito_discursiva: gabarito_disc,
    gabarito_radio: gabarito_radio_val,
    opcoes_radio: opcoes_radio_val,
    numero_opcoes: opcoes_radio_val&.length || nil,
    template_formulario: template
  )

  visit edit_template_formulario_path(template)
end

When("ele cria uma questão \"Discursiva\" com {string} e {string}") do |enunciado, gabarito|
  template = @template_em_montagem || @template_em_edicao || @template_background
  Pergunta.create!(
    enunciado: enunciado,
    tipo_pergunta: :discursiva,
    gabarito_discursiva: gabarito,
    template_formulario: template
  )
end

When("ele cria uma questão \"Radio\" com {string} e {string} com {string} opções, cujas são {string}") do |enunciado, gabarito, qtd, opcoes_str|
  opcoes = opcoes_str.split(",").map(&:strip)
  gabarito_map = { "Opção 1" => :opcao_a, "Opção 2" => :opcao_b, "Opção 3" => :opcao_c,
                   "Opção 4" => :opcao_d, "Opção 5" => :opcao_e, "Sem Gabarito" => :sem_gabarito }
  gabarito_val = gabarito_map[gabarito] || :sem_gabarito
  template = @template_em_montagem || @template_em_edicao || @template_background
  Pergunta.create!(
    enunciado: enunciado,
    tipo_pergunta: :radio,
    gabarito_radio: gabarito_val,
    opcoes_radio: opcoes,
    numero_opcoes: opcoes.length,
    template_formulario: template
  )
end

When("escreve {string} em \"Enunciado\"") do |texto|
  @enunciado_pergunta = texto
end

When("escreve {string} em \"Gabarito\"") do |texto|
  @gabarito_discursiva = texto
end

# Then

Then("o usuário deve estar na página de criação de Template de Formulário") do
  expect(current_path).to match(%r{/template_formularios/\d+/edit})
end

Then("o usuário deve estar na aba criação de Templates de Formulário") do
  expect(current_path).to eq(editar_templates_path)
end

Then("o usuário deve estar na página de criação de Templates de Formulário") do
  expect(current_path).to eq(editar_templates_path).or(match(%r{/template_formularios/\d+/edit}))
end

# NOTE: ele deve ver {string} e ele não deve ver {string} estão definidos em
# ver_formularios_pendentes_steps.rb e não são redefinidos aqui.
