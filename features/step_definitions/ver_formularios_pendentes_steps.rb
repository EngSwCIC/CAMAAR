SENHA_FORM_PENDENTES = 'Senha123'

# Background — cria usuários para ver_formularios_pendentes e ver_resultados_formulario

Given('que os seguintes usuários existam:') do |table|
  @usuarios = {}
  table.hashes.each do |row|
    email  = row['email'].strip
    perfil = row['perfil'].strip.downcase
    role   = case perfil
             when 'admin' then :admin
             when 'professor' then :professor
             else :estudante
             end

    usuario = Usuario.create!(
      nome:                  row['nome'].strip,
      email:                 email,
      password:              SENHA_FORM_PENDENTES,
      password_confirmation: SENHA_FORM_PENDENTES,
      role:                  role
    )

    profile = case role
              when :admin
                depto_nome = row['departamento']&.strip.presence || 'Depto Padrão'
                depto = Departamento.find_or_create_by!(nome_departamento: depto_nome)
                Admin.find_or_create_by!(usuario: usuario, departamento: depto)
                CriadorFormulario.find_or_create_by!(usuario: usuario)
                { admin: Admin.find_by(usuario: usuario) }
              when :professor
                Professor.find_or_create_by!(usuario: usuario)
                { professor: Professor.find_by(usuario: usuario) }
              when :estudante
                Estudante.find_or_create_by!(usuario: usuario)
                { estudante: Estudante.find_by(usuario: usuario) }
              end

    @usuarios[email] = { usuario: usuario }.merge(profile || {})
  end
end

# Shared Given

Given('que o usuário esta logado como {string}') do |email|
  @usuario_logado = @usuarios[email]&.fetch(:usuario, nil) || Usuario.find_by!(email: email)
  visit login_path
  fill_in 'Email', with: email
  fill_in 'Senha', with: SENHA_FORM_PENDENTES
  find('input[type="submit"]').click
end

Given('os seguintes formulários estão atribuidos ao usuário:') do |table|
  departamento = Departamento.find_or_create_by!(nome_departamento: 'Depto Formulários')
  materia = Materia.create!(
    codigoMateria: "FPEND#{rand(1000)}",
    nome_materia:  'Matéria Formulários',
    departamento:  departamento
  )

  admin_u = Usuario.find_or_create_by!(email: 'admin.criador.form@escola.com') do |u|
    u.nome = 'Admin Criador'
    u.password = 'Admin123'
    u.password_confirmation = 'Admin123'
    u.role = :admin
  end
  Admin.find_or_create_by!(usuario: admin_u, departamento: departamento)
  criador  = CriadorFormulario.find_or_create_by!(usuario: admin_u)
  template = TemplateFormulario.create!(criador_formulario: criador, nome_template: "Tmpl #{rand(1000)}")

  usuario_logado_obj = @usuario_logado.is_a?(Hash) ? @usuario_logado[:usuario] : @usuario_logado
  estudante_record = usuario_logado_obj&.estudante
  professor_record = usuario_logado_obj&.professor

  if estudante_record
    prof_u = Usuario.find_or_create_by!(email: 'prof.turma.form@escola.com') do |u|
      u.nome = 'Prof Turma Form'
      u.password = SENHA_FORM_PENDENTES
      u.password_confirmation = SENHA_FORM_PENDENTES
      u.role = :professor
    end
    professor_turma = Professor.find_or_create_by!(usuario: prof_u)
    turma = Turma.create!(materia: materia, professor: professor_turma, semestre_string: '2026/1')
    Matricula.find_or_create_by!(estudante: estudante_record, turma: turma)
    publico = true
  else
    turma  = Turma.create!(materia: materia, professor: professor_record, semestre_string: '2026/1')
    publico = false
  end

  table.hashes.each do |row|
    Formulario.create!(
      nome_formulario:     row['nomeFormulario'].strip,
      template_formulario: template,
      turma:               turma,
      criador_formulario:  criador,
      publico_estudante:   publico
    )
  end
end

Given('não existem formulários atribuidos ao usuário') do
  # no-op — DatabaseCleaner garante estado limpo
end

Given('que o usuário não está logado') do
  # no-op — nenhuma sessão iniciada
end

# Shared When

When('o usuário acessa a aba de {string}') do |aba|
  case aba
  when 'Respostas Formulários', 'Relatórios'
    visit relatorios_path
  when 'Formulários Pendentes', 'Formulários'
    visit avaliacoes_path
  else
    visit avaliacoes_path
  end
end

When('o usuário acessa a aba de {string} de {string}') do |aba, _dono_email|
  case aba
  when 'Respostas Formulários', 'Relatórios'
    visit relatorios_path
  else
    visit avaliacoes_path
  end
end

# Shared Then — shared across all features

Then('ele deve ver {string}') do |texto|
  expect(page).to have_content(texto)
end

Then('ele não deve ver {string}') do |texto|
  expect(page).not_to have_content(texto)
end

Then('o usuário deve ser redirecionado à página de Login') do
  expect(current_path).to eq(login_path)
end

Then('o usuário deve ser redirecionado à página de {string}') do |pagina|
  case pagina
  when 'Login'
    expect(current_path).to eq(login_path)
  when 'Menu Principal'
    expect(current_path).to match(%r{\A/})
  else
    expect(page).to have_content(pagina)
  end
end
