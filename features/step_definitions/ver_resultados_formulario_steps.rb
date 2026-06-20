SENHA_VER_RES = "Senha123"

def criar_formularios_do_departamento(dep_nome, formularios_data)
  depto = Departamento.find_or_create_by!(nome_departamento: dep_nome)
  materia = Materia.find_or_create_by!(codigoMateria: "VRD001") do |m|
    m.nome_materia = "Matéria Ver Resultados"
    m.departamento = depto
  end

  prof_u = @usuarios.values.find { |h| h[:usuario]&.professor? }&.dig(:usuario)
  prof_u ||= Usuario.find_or_create_by!(email: "prof.ver.res@escola.com") do |u|
    u.nome = "Prof Ver Res"
    u.password = SENHA_VER_RES
    u.password_confirmation = SENHA_VER_RES
    u.role = :professor
  end
  professor = Professor.find_or_create_by!(usuario: prof_u)
  turma = Turma.find_or_create_by!(materia: materia, professor: professor) do |t|
    t.semestre_string = "2026/1"
    t.numero_turma = 1
  end

  admin_u = @usuarios.values.find { |h| h[:usuario]&.admin? }&.dig(:usuario)
  admin_u ||= Usuario.find_or_create_by!(email: "admin.ver.res@escola.com") do |u|
    u.nome = "Admin Ver Res"
    u.password = SENHA_VER_RES
    u.password_confirmation = SENHA_VER_RES
    u.role = :admin
  end
  Admin.find_or_create_by!(usuario: admin_u, departamento: depto)
  criador_geral = CriadorFormulario.find_or_create_by!(usuario: admin_u)

  formularios_data.each do |row|
    dono_email  = row["dono"].strip
    dono_u      = @usuarios.dig(dono_email, :usuario) || Usuario.find_by(email: dono_email)
    criador_row = dono_u ? CriadorFormulario.find_or_create_by!(usuario: dono_u) : criador_geral

    template = TemplateFormulario.create!(
      nome_template: "Tmpl #{row['nomeFormulario']} #{rand(9999)}",
      criador_formulario: criador_row
    )
    Formulario.find_or_create_by!(nome_formulario: row["nomeFormulario"].strip, turma: turma) do |f|
      f.criador_formulario = criador_row
      f.template_formulario = template
      f.publico_estudante = true
    end
  end
end

# Background step (unique to this feature - column "departamento" in table)

Given(/^o departamento do\/a "([^"]+)" possui os seguintes formulários:$/) do |dep_nome, table|
  criar_formularios_do_departamento(dep_nome, table.hashes)
end

# Shared Then (these are in ver_formularios_pendentes_steps.rb, NOT redefined here)
# ele deve ver {string} → shared
# ele não deve ver {string} → shared
# o usuário deve ser redirecionado à página de {string} → shared
# que o usuário esta logado como {string} → shared
# que os seguintes usuários existam: → shared
# o usuário acessa a aba de {string} → shared
