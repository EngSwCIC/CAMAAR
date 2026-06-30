# Step definitions de criar_formularios_discentes.feature.
#
# Reutiliza vários steps de criacao_formulario_steps.rb e
# ver_formularios_pendentes_steps.rb (ex.: "ele deve ver {string}",
# "que o usuário tem permissões para criacao de Formulario",
# "que os seguintes Templates existem:", "ele clica no botão \"Criar\"").
# Aqui ficam apenas os steps específicos deste fluxo.

SENHA_DISCENTES = 'Senha123'

# Background

Given('que o usuário está na aba de criação de formulários') do
  # Marca que estamos no fluxo de discentes/docentes: Turma e Público-Alvo
  # serão escolhidos por steps próprios, então o step compartilhado
  # "ele clica no botão \"Criar\"" não deve auto-selecioná-los.
  @fluxo_discentes = true
  visit enviar_formularios_path
end

Given('que existem as seguintes Turmas no sistema:') do |table|
  @turmas_por_codigo ||= {}
  @turmas_vis_rel ||= {}
  depto = Departamento.find_or_create_by!(nome_departamento: 'Depto Turmas Discentes')

  table.hashes.each do |row|
    codigo     = row['turma'].strip
    disciplina = row['disciplina'].strip
    semestre   = row['semestre'].strip

    materia = Materia.find_or_create_by!(codigoMateria: codigo) do |m|
      m.nome_materia = disciplina
      m.departamento = depto
    end

    email_prof = "docente.#{codigo.downcase.gsub(/\W/, '')}@escola.com"
    prof_usuario = Usuario.find_or_create_by!(email: email_prof) do |u|
      u.nome = "Docente #{codigo}"
      u.password = SENHA_DISCENTES
      u.password_confirmation = SENHA_DISCENTES
      u.role = :professor
    end
    professor = Professor.find_or_create_by!(usuario: prof_usuario)

    turma = Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
      t.numero_turma    = codigo[/\d+/].to_i
      t.semestre_string = semestre
    end

    @turmas_por_codigo[codigo] = turma
    @turmas_vis_rel[codigo]    = turma
  end
end

Given('que a turma {string} possui discentes matriculados e docentes vinculados') do |codigo|
  turma = @turmas_por_codigo.fetch(codigo)

  # Docente vinculado: a turma já possui um professor (criado no step anterior).
  # Aqui garantimos discentes matriculados ativos.
  2.times do |i|
    estudante_usuario = Usuario.create!(
      nome:                  "Discente #{i + 1} #{codigo}",
      email:                 "discente#{i + 1}.#{codigo.downcase}@escola.com",
      password:              SENHA_DISCENTES,
      password_confirmation: SENHA_DISCENTES,
      role:                  :estudante
    )
    estudante = Estudante.create!(usuario: estudante_usuario)
    Matricula.create!(estudante: estudante, turma: turma, trancado: false)
  end
end

Given('que a turma {string} não possui discentes matriculados') do |codigo|
  turma = @turmas_por_codigo.fetch(codigo)
  expect(turma.matriculas).to be_empty
end

# Given (meio de cenário)

Given('já existe um formulário chamado {string} para o público {string} da turma {string}') do |nome, publico, codigo|
  turma   = @turmas_por_codigo.fetch(codigo)
  criador = @criador_bg || CriadorFormulario.first

  Formulario.create!(
    nome_formulario:     nome,
    template_formulario: TemplateFormulario.first,
    turma:               turma,
    criador_formulario:  criador,
    publico_estudante:   publico.strip.casecmp('Discente').zero?
  )
end

Given('que o usuário não tem permissões para criacao de Formulario') do
  # O Background já logou um administrador; aqui trocamos por um usuário
  # sem privilégios (estudante) para validar o bloqueio de acesso.
  sem_permissao = Usuario.create!(
    nome:                  'Usuario Sem Permissao',
    email:                 'sem.permissao.form@escola.com',
    password:              SENHA_DISCENTES,
    password_confirmation: SENHA_DISCENTES,
    role:                  :estudante
  )
  Estudante.create!(usuario: sem_permissao)

  visit login_path
  fill_in 'Email', with: sem_permissao.email
  fill_in 'Senha', with: SENHA_DISCENTES
  find('input[type="submit"]').click
end

# When

When('seleciona {string} em "Público-Alvo"') do |publico|
  choose publico
end

When('seleciona {string} em "Turma"') do |codigo|
  turma = @turmas_por_codigo.fetch(codigo)
  opcao = "#{turma.materia.nome_materia} - Turma #{turma.numero_turma} - #{turma.semestre_string}"
  select opcao, from: 'Turma'
end

When('deixa o campo "Nome do Formulário" em branco') do
  fill_in 'Nome do Formulário', with: ''
end

When('ele tenta acessar a aba de criação de formulários') do
  visit enviar_formularios_path
end

# Then

Then('o formulário deve estar disponível para os discentes da turma {string}') do |codigo|
  turma = @turmas_por_codigo.fetch(codigo)
  expect(Formulario.where(turma_id: turma.id, publico_estudante: true)).to exist
end

Then('o formulário deve estar disponível para os docentes da turma {string}') do |codigo|
  turma = @turmas_por_codigo.fetch(codigo)
  expect(Formulario.where(turma_id: turma.id, publico_estudante: false)).to exist
end

# "o sistema não deve permitir o acesso" já está definido em
# atualizar_base_dados_sigaa_steps.rb (verifica status 403) e é reaproveitado aqui.
