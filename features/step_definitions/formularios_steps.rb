# frozen_string_literal: true

def administrador_formularios
  @admin ||= usuario_atual || estado[:usuario_administrador] || usuario_administrador
  @departamento = @admin.perfil_adm.departamento
  @admin
end

Given("que existem formulários criados para o semestre atual") do
  administrador_formularios
  @template = criar_template_com_questoes(titulo: "Avaliação de Disciplina")
  @turma_a = criar_turma_do_nome_exibicao("Estrutura de Dados - Turma A")
  @turma_b = criar_turma_do_nome_exibicao("Banco de Dados - Turma B")
  @formularios = [
    criar_formulario_publicado(turma: @turma_a, template: @template, publico_alvo: :docentes),
    criar_formulario_publicado(turma: @turma_b, template: @template, publico_alvo: :discentes)
  ]
end

Given("que nenhum formulário foi gerado para o semestre vigente") do
  administrador_formularios
  turma_passada = criar_turma_do_nome_exibicao(
    "Disciplina Anterior - Turma A",
    ano: Date.current.year - 1,
    semestre: :segundo
  )
  criar_formulario_publicado(turma: turma_passada, publico_alvo: :docentes)
  expect(Formulario.do_semestre_atual.count).to eq(0)
end

Given("que existe um template cadastrado chamado {string}") do |titulo|
  administrador_formularios
  @template = criar_template_com_questoes(titulo: titulo)
end

Given("que existe um template sem questões chamado {string}") do |titulo|
  administrador_formularios
  @template_vazio = Template.new(
    adm: @admin.perfil_adm,
    titulo: titulo,
    descricao: "Template sem questões",
    criado_em: Time.current
  )
  @template_vazio.save!(validate: false)
end

Given("que existem as turmas {string} e {string} cadastradas no semestre atual") do |nome_turma_a, nome_turma_b|
  @turma_a = criar_turma_do_nome_exibicao(nome_turma_a)
  @turma_b = criar_turma_do_nome_exibicao(nome_turma_b)
end

Given("que existe o professor {string} vinculado à turma {string}") do |nome_professor, nome_turma|
  turma = turma_por_referencia(nome_turma)
  professor = usuario_docente(
    nome: nome_professor,
    email: "#{nome_professor.parameterize}@unb.br",
    departamento: turma.departamento
  )

  ParticipacaoTurma.find_or_create_by!(
    usuario: professor,
    turma: turma,
    tipo_participacao: :docente
  )
end

Given("que existe o professor {string} no meu departamento") do |nome_professor|
  administrador_formularios
  usuario_docente(
    nome: nome_professor,
    email: "#{nome_professor.parameterize}@unb.br",
    departamento: @departamento
  )
end

Given("que existe uma turma de outro departamento chamada {string}") do |nome_turma|
  outro_departamento = Departamento.create!(nome: "Outro Departamento #{SecureRandom.hex(2)}")
  @turma_outro_departamento = criar_turma_do_nome_exibicao(nome_turma, departamento: outro_departamento)
end

Given("que existe uma turma passada chamada {string}") do |nome_turma|
  @turma_passada = criar_turma_do_nome_exibicao(
    nome_turma,
    ano: Date.current.year - 1,
    semestre: :segundo
  )
end

Given("que existe um formulário já publicado para a turma {string} com público-alvo {string}") do |nome_turma, publico_alvo|
  turma = turma_por_referencia(nome_turma)
  @formulario_existente = Formularios::CreateFromTemplate.call(
    template_id: @template.id,
    turma_ids: [ turma.id ],
    publico_alvo: valor_publico_alvo_formulario(publico_alvo),
    perfil_adm: administrador_formularios.perfil_adm
  ).sole
end

Given("que existe um formulário criado por outro administrador do meu departamento") do
  administrador_formularios
  outro_admin = criar_outro_administrador_formularios(@departamento)
  template = template_formulario_para_admin("Avaliação de Outro Administrador", outro_admin)
  turma = criar_turma_do_nome_exibicao("Compiladores - Turma A")
  @formulario_outro_admin = criar_formulario_publicado(turma: turma, template: template, adm: outro_admin)
end

Given("que existe um formulário criado em outro departamento") do
  outro_departamento = Departamento.create!(nome: "Departamento Externo #{SecureRandom.hex(2)}")
  outro_admin = criar_outro_administrador_formularios(outro_departamento)
  template = template_formulario_para_admin("Formulário Externo", outro_admin)
  turma = criar_turma_do_nome_exibicao("Sistemas Digitais - Turma A", departamento: outro_departamento)
  @formulario_outro_departamento = criar_formulario_publicado(turma: turma, template: template, adm: outro_admin)
end

Given("que existe um formulário criado em semestre anterior") do
  administrador_formularios
  turma = criar_turma_do_nome_exibicao(
    "Disciplina Encerrada - Turma A",
    ano: Date.current.year - 1,
    semestre: :segundo
  )
  @formulario_semestre_anterior = criar_formulario_publicado(turma: turma, publico_alvo: :docentes)
end

Given("que existe um formulário criado para um template removido") do
  administrador_formularios
  template = criar_template_com_questoes(titulo: "Template que será removido")
  turma = criar_turma_do_nome_exibicao("Paradigmas de Programação - Turma A")
  @formulario_template_removido = criar_formulario_publicado(turma: turma, template: template)
  template.destroy!
  @formulario_template_removido.reload
end

Given("que estou na página de criação de formulários") do
  visit new_formulario_path
end

Given("que estou visualizando o template cadastrado chamado {string}") do |titulo|
  @template = Template.find_by!(titulo: titulo)
  visit template_path(@template)
end

Given("que selecionei o template {string}") do |titulo|
  administrador_formularios
  @template = criar_template_com_questoes(titulo: titulo)
end

Given("selecionei a turma {string}") do |nome_turma|
  @turma = criar_turma_do_nome_exibicao(nome_turma)
end

When("estou na página de criação de formulários filtrando pela matéria {string}") do |nome_materia|
  materia = Materia.find_by!(nome: nome_materia)
  visit new_formulario_path(materia_id: materia.id)
end

When("estou na página de criação de formulários") do
  visit new_formulario_path
end

When("volto para a página de criação de formulários") do
  visit new_formulario_path
end

When("eu seleciono o template {string}") do |titulo|
  selecionar_template_no_formulario(titulo)
end

When("solicito criar um formulário a partir desse template") do
  click_link "Usar em Formulário"
end

When("seleciono as turmas {string} e {string}") do |nome_turma_a, nome_turma_b|
  selecionar_turma_no_formulario(nome_turma_a)
  selecionar_turma_no_formulario(nome_turma_b)
end

When("seleciono a turma {string}") do |nome_turma|
  selecionar_turma_no_formulario(nome_turma)
end

When("não seleciono nenhuma turma") do
  page.all('input[name="turma_ids[]"]', visible: :all).each do |checkbox|
    checkbox.set(false) if checkbox.checked?
  end
end

When(/^clico em "(Publicar formulário|Continuar|Confirmar Publicação)"$/) do |botao|
  if page.has_button?(botao)
    click_button botao
  elsif botao == "Confirmar Publicação" && page.has_button?("Publicar formulário")
    click_button "Publicar formulário"
  elsif page.has_link?(botao)
    click_link botao
  elsif %w[Continuar Confirmar\ Publicação].include?(botao)
    true
  else
    raise Capybara::ElementNotFound, "Não encontrei botão ou link #{botao.inspect}"
  end
end

Given("que estou na etapa de definição de público-alvo") do
  visit new_formulario_path(template_id: @template.id)
  selecionar_template_no_formulario(@template.titulo)
  selecionar_turma_no_formulario(@turma.nome_exibicao)
end

When("seleciono a opção de público-alvo como {string}") do |publico_alvo|
  selecionar_publico_alvo_no_dropdown(publico_alvo)
end

When("eu seleciono a opção de público-alvo como {string}") do |publico_alvo|
  selecionar_publico_alvo_no_dropdown(publico_alvo)
end

When("eu não seleciono nem {string} e nem {string}") do |_, _|
  limpar_publico_alvo_no_dropdown
end

When("confirmo a publicação do formulário") do
  click_button "Publicar formulário"
end

When("tento publicar formulário para a turma {string} pela requisição") do |nome_turma|
  turma = turma_por_referencia(nome_turma)
  page.driver.submit(
    :post,
    formularios_path,
    {
      template_id: @template.id,
      turma_ids: [ turma.id ],
      publico_alvo: "docentes"
    }
  )
end

When("eu acesso o painel de gerenciamento de formulários") do
  visit formularios_path
end

When("eu acesso a página de formulários criados") do
  visit formularios_path
end

Then("devo ver o controle segmentado de público-alvo com as opções {string} e {string}") do |docentes, discentes|
  expect(page).to have_css(".formulario-publico-segmented", visible: :all)
  expect(page).to have_css("input[name='publico_alvo'][type='radio'][value='docentes']", visible: :all)
  expect(page).to have_css("input[name='publico_alvo'][type='radio'][value='discentes']", visible: :all)
  expect(page).to have_content(docentes)
  expect(page).to have_content(discentes)
end

Then("devo ver todas as turmas dentro da mesma caixa de seleção") do
  within(".formulario-classes__box") do
    expect(page).to have_css(".formulario-choice-card--class", minimum: 2)
    expect(page).to have_content(@turma_a.nome_exibicao)
    expect(page).to have_content(@turma_b.nome_exibicao)
  end

  expect(page).not_to have_css(".formulario-class-group", visible: :all)
end

Then("devo ver o filtro de turmas com seções recolhidas para matéria e professor") do
  expect(page).to have_css("#formulario-class-filter-menu", visible: :all)
  expect(page).to have_css(".formulario-class-filter__section summary", text: "Matéria", visible: :all)
  expect(page).to have_css(".formulario-class-filter__section summary", text: "Professor", visible: :all)
  expect(page).not_to have_css(".formulario-class-filter__section[open]", visible: :all)
end

Then("devo ver buscas específicas para matéria e professor no filtro de turmas") do
  expect(page).to have_css("input[placeholder='Pesquisar matéria']", visible: :all)
  expect(page).to have_css("input[placeholder='Pesquisar professor']", visible: :all)
end

Then("devo ver {string} e {string} como opções de filtro por professor") do |professor_a, professor_b|
  expect(page).to have_css("[data-filter-type='professor']", text: professor_a, visible: :all)
  expect(page).to have_css("[data-filter-type='professor']", text: professor_b, visible: :all)
end

Then("o formulário deve ser gerado com sucesso para ambas as turmas") do
  formularios = Formulario.where(turma: [ @turma_a, @turma_b ], template: @template)
  expect(formularios.count).to eq(2)

  [ @turma_a, @turma_b ].each do |turma|
    formulario = formularios.find_by!(turma: turma)
    expect(formulario.template).to eq(@template)
    expect(formulario.publico_alvo).to eq("docentes")
    expect(formulario.questoes.order(:id).pluck(:enunciado)).to eq(
      questoes_ordenadas_do_template(@template).map(&:enunciado)
    )
  end
end

Then("devo estar na página de criação de formulários com o template {string} selecionado") do |titulo|
  expect(page).to have_current_path(new_formulario_path(template_id: @template.id))
  esperar_template_selecionado_no_formulario(titulo)
end

Then("eu devo ver uma lista com todos os formulários criados, exibindo o template base, a turma e o público-alvo de cada um") do
  expect(page).to have_css(".template-form__card", count: @formularios.size)

  @formularios.each do |formulario|
    within(".template-form__card", text: formulario.turma.nome_exibicao) do
      expect(page).to have_content(formulario.template.titulo)
      publico_label = formulario.docentes? ? "Docentes" : "Discentes"
      expect(page).to have_content(publico_label)
    end
  end
end

Then("ao acessar um formulário listado devo ver o botão {string}") do |texto_botao|
  visit formulario_path(@formularios.first)
  expect(page).to have_link(texto_botao)
end

Then("devo ver a seção {string}") do |titulo|
  expect(page).to have_css("section", text: titulo)
end

Then("devo ver a seção {string} com subtítulo {string}") do |titulo, subtitulo|
  within("section", text: titulo) do
    expect(page).to have_content(subtitulo)
  end
end

Then("devo ver o formulário de outro administrador na seção {string}") do |titulo_secao|
  within("section", text: titulo_secao) do
    expect(page).to have_content(@formulario_outro_admin.template.titulo)
    expect(page).to have_content(@formulario_outro_admin.turma.nome_exibicao)
  end
end

Then("eu devo ver a listagem vazia") do
  expect(page).not_to have_css(".template-form__card")
end

Then("a mensagem {string} deve ser exibida na tela") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("devo ver apenas os formulários vigentes do meu departamento") do
  @formularios.each do |formulario|
    expect(page).to have_content(formulario.turma.nome_exibicao)
  end

  expect(page).not_to have_content(@formulario_outro_departamento.template.titulo)
  expect(page).not_to have_content(@formulario_semestre_anterior.turma.nome_exibicao)
end

Then("devo ver o formulário com template removido na listagem") do
  expect(page).to have_content("Template removido")
  expect(page).to have_content(@formulario_template_removido.turma.nome_exibicao)
end

Then("ao acessar esse formulário devo ver o template como {string}") do |texto|
  visit formulario_path(@formulario_template_removido)
  expect(page).to have_content(texto)
  expect(page).to have_content(@formulario_template_removido.turma.nome_exibicao)
end

Then(/^devo ver a mensagem "Formulário criado com sucesso para as turmas selecionadas"$/) do
  expect(page).to have_content("Formulário criado com sucesso para as turmas selecionadas")
end

Then("eu devo ver uma mensagem de erro dizendo {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("eu devo ver o alerta {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Then("nenhum formulário deve ser gerado") do
  expect(Formulario.count).to eq(0)
end

Then("o formulário não deve ser publicado") do
  expect(Formulario.count).to eq(0)
end

Then("deve existir apenas um formulário para a turma {string}") do |nome_turma|
  turma = turma_por_referencia(nome_turma)
  expect(turma.formularios.count).to eq(1)
end

Then("devo ver a turma {string} disponível para seleção") do |nome_turma|
  expect(page).to have_css(".formulario-choice-card--class", text: nome_turma)
end

Then("não devo ver a turma {string} disponível para seleção") do |nome_turma|
  expect(page).not_to have_css(".formulario-choice-card--class", text: nome_turma)
end

Then("o formulário deve ficar disponível apenas para os alunos matriculados na turma {string}") do |nome_turma|
  turma = turma_por_referencia(nome_turma)
  formulario = turma.reload.formularios.sole
  expect(formulario.publico_alvo).to eq("discentes")

  discente = usuario_participante(email: "discente-formulario@unb.br")
  ParticipacaoTurma.find_or_create_by!(usuario: discente, turma: turma, tipo_participacao: :discente)
  formulario.criar_avaliacoes_pendentes!

  login_como(discente)
  visit avaliacoes_pendentes_path
  expect(page).to have_content(turma.nome_exibicao)
end

Then("os docentes da turma não devem ter acesso para responder a este formulário") do
  turma = @turma || turma_por_referencia("Estrutura de Dados - Turma C")
  docente = usuario_docente(email: "docente-formulario@unb.br", departamento: turma.departamento)
  ParticipacaoTurma.find_or_create_by!(usuario: docente, turma: turma, tipo_participacao: :docente)

  login_como(docente)
  visit avaliacoes_pendentes_path
  expect(page).not_to have_content(@template.titulo)
end

Then("o formulário deve ficar disponível apenas para os professores vinculados à turma {string}") do |nome_turma|
  turma = turma_por_referencia(nome_turma)
  formulario = turma.reload.formularios.sole
  expect(formulario.publico_alvo).to eq("docentes")

  docente = usuario_docente(email: "docente-formulario@unb.br", departamento: turma.departamento)
  ParticipacaoTurma.find_or_create_by!(usuario: docente, turma: turma, tipo_participacao: :docente)
  formulario.criar_avaliacoes_pendentes!

  login_como(docente)
  visit avaliacoes_pendentes_path
  expect(page).to have_content(turma.nome_exibicao)
end

Then("devem existir formulários para {string} e {string} na turma {string}") do |publico_a, publico_b, nome_turma|
  turma = turma_por_referencia(nome_turma)
  publicos = turma.formularios.order(:publico_alvo).pluck(:publico_alvo)
  expect(publicos).to contain_exactly(
    valor_publico_alvo_formulario(publico_a),
    valor_publico_alvo_formulario(publico_b)
  )
end

def selecionar_turma_no_formulario(nome_turma)
  turma = turma_por_referencia(nome_turma)
  find("input[name='turma_ids[]'][value='#{turma.id}']", visible: :all).set(true)
end

def criar_formulario_publicado(turma:, template: nil, publico_alvo: :docentes, adm: nil)
  adm ||= administrador_formularios.perfil_adm
  template ||= template_formulario_para_admin("Avaliação de teste", adm)

  Formulario.create!(
    adm: adm,
    turma: turma,
    template: template,
    publico_alvo: publico_alvo
  ).tap do |formulario|
    copiar_questoes_do_template_para_formulario(formulario, template)
  end
end

def criar_turma_do_nome_exibicao(nome_exibicao, departamento: nil, ano: Date.current.year, semestre: Turma.semestre_atual)
  @turmas_por_nome ||= {}
  cache_key = [ nome_exibicao, departamento&.id || administrador_formularios.perfil_adm.departamento_id, ano, semestre ]
  return @turmas_por_nome[cache_key] if @turmas_por_nome.key?(cache_key)

  materia_nome, codigo_turma = nome_exibicao.split(" - Turma ", 2)
  departamento ||= administrador_formularios.perfil_adm.departamento
  materia = Materia.find_or_initialize_by(codigo: codigo_para(materia_nome))
  materia.nome = materia_nome
  materia.departamento = departamento
  materia.save!

  @turmas_por_nome[cache_key] = Turma.find_or_create_by!(
    materia: materia,
    ano: ano,
    semestre: semestre,
    numero: Turma.numero_de_codigo_exibicao(codigo_turma)
  )
end

def turma_por_referencia(nome)
  return @turma if @turma&.nome_exibicao == nome

  (@turmas_por_nome || {}).each_value do |turma|
    return turma if turma.nome_exibicao == nome
  end

  if nome.include?(" - Turma ")
    criar_turma_do_nome_exibicao(nome)
  else
    Turma.joins(:materia).find_by!(materias: { nome: nome })
  end
end

def valor_publico_alvo_formulario(publico_alvo)
  publico_alvo.to_s.downcase
end

def criar_outro_administrador_formularios(departamento)
  usuario = usuario_com_email(
    nome: "Outro Administrador #{SecureRandom.hex(2)}",
    email: "outro-admin-#{SecureRandom.hex(4)}@unb.br",
    senha: "Admin123"
  )
  PerfilAdm.create!(usuario: usuario, departamento: departamento)
end

def template_formulario_para_admin(titulo, adm)
  Template.create!(
    titulo: titulo,
    descricao: "Template de teste",
    adm: adm,
    criado_em: Time.current,
    utilizacoes_questoes_attributes: [
      {
        numero: 1,
        questao_attributes: {
          enunciado: "Como você avalia a disciplina?",
          tipo: :discursiva
        }
      }
    ]
  )
end
