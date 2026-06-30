SENHA_ADMIN_CRIACAO = 'Admin123'
SENHA_PROF_CRIACAO  = 'Senha123'

# Background

Given('que os seguintes Templates existem:') do |table|
  bg_admin = Usuario.create!(
    nome:                  'Admin BG Templates',
    email:                 'admin.bg.templates@escola.com',
    password:              SENHA_ADMIN_CRIACAO,
    password_confirmation: SENHA_ADMIN_CRIACAO,
    role:                  :admin
  )
  @criador_bg = CriadorFormulario.create!(usuario: bg_admin)

  @templates_por_nome = {}
  table.hashes.each do |row|
    nome     = row['templateName'].strip
    template = TemplateFormulario.create!(nome_template: nome, criador_formulario: @criador_bg)
    @templates_por_nome[nome] = template
  end
end

Given('que eles contém as seguintes Perguntas estilo radio:') do |table|
  @templates_por_nome.each_value do |template|
    table.hashes.each do |row|
      opcoes       = row['opcoesRadio'].split(',').map(&:strip)
      gabarito_sym = Pergunta.gabarito_radios.key(row['gabaritoRadio'].to_i)
      Pergunta.create!(
        enunciado:          row['Enunciado'].strip,
        tipo_pergunta:      :radio,
        gabarito_radio:     gabarito_sym,
        opcoes_radio:       opcoes,
        numero_opcoes:      opcoes.length,
        template_formulario: template
      )
    end
  end
end

# Given

Given('que o usuário tem permissões para criacao de Formulario') do
  admin_u = Usuario.create!(
    nome:                  'Admin Formulario',
    email:                 'admin.form.criacao@escola.com',
    password:              SENHA_ADMIN_CRIACAO,
    password_confirmation: SENHA_ADMIN_CRIACAO,
    role:                  :admin
  )
  @admin_criador = CriadorFormulario.create!(usuario: admin_u)

  depto    = Departamento.find_or_create_by!(nome_departamento: 'Depto Criacao Form')
  materia  = Materia.create!(
    codigoMateria: 'CRFORM01',
    nome_materia:  'Matéria Criação Form',
    departamento:  depto
  )
  prof_u   = Usuario.create!(
    nome:                  'Prof Criacao Form',
    email:                 'prof.crform@escola.com',
    password:              SENHA_PROF_CRIACAO,
    password_confirmation: SENHA_PROF_CRIACAO,
    role:                  :professor
  )
  professor      = Professor.create!(usuario: prof_u)
  @turma_criacao = Turma.create!(
    materia:        materia,
    professor:      professor,
    numero_turma:   1,
    semestre_string: '2026/1'
  )

  visit login_path
  fill_in 'Email', with: admin_u.email
  fill_in 'Senha', with: SENHA_ADMIN_CRIACAO
  find('input[type="submit"]').click
end

Given('ele está na aba criação de formulários') do
  visit enviar_formularios_path
end

# When

When('ele clica no botão "Criar Formulário"') do
  # (Re)abre a página de criação. Importante porque o Background pode criar
  # Templates/Turmas após o primeiro acesso à aba; revisitar garante que o
  # formulário seja renderizado já com os Templates disponíveis (select habilitado).
  visit enviar_formularios_path
end

When('escreve {string} em "Nome do Formulário"') do |nome|
  fill_in 'Nome do Formulário', with: nome
end

When('seleciona {string} de "Templates"') do |template_name|
  select template_name, from: 'Template'
end

When('ele clica no botão "Criar"') do
  # No fluxo de criacao_formulario.feature não há seleção explícita de Turma
  # e Público-Alvo, então preenchemos com padrões (Docente + turma do Background).
  # No fluxo de criar_formularios_discentes.feature essas escolhas são feitas em
  # steps próprios, então aqui apenas submetemos o formulário.
  unless @fluxo_discentes
    opt_text = "#{@turma_criacao.materia.nome_materia} - Turma #{@turma_criacao.numero_turma} - #{@turma_criacao.semestre_string}"
    select opt_text, from: 'Turma'
    choose 'Docente'
  end
  click_button 'Criar'
end

# Then

Then('o usuário deve estar na aba de criação de formulários') do
  expect(current_path).to eq(enviar_formularios_path)
end

Then('o formulário {string} deve existir') do |nome|
  expect(Formulario.find_by(nome_formulario: nome)).to be_present
end

Then('o usuário deve estar na página do formulário de criação de formulários') do
  expect(current_path).to eq(enviar_formularios_path)
end
