# frozen_string_literal: true

# Step definitions for: Criar formulário baseado em template

Dado('que eu estou logado como administrador') do
  depto = Departamento.find_or_create_by!(nome: 'Departamento', codigo: 'TST')

  @admin = Administrador.find_or_create_by!(email: 'admin@unb.br') do |u|
    u.senha_hash = '123456'
    u.nome = 'Admin'
    u.matricula = '123456789'
    u.departamento = depto
  end

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)

  allow_any_instance_of(AdminController).to receive(:set_admin) do |controller|
    controller.instance_variable_set(:@admin, @admin)
  end
end

Dado('que existe um template chamado {string} com as seguintes perguntas:') do |nome_template, table|
  @admin ||= Administrador.first

  @template = Template.new(nome: nome_template, administrador: @admin)

  table.hashes.each_with_index do |row, index|
    elemento = @template.elementos.build(enunciado: row['Pergunta'], ordem: index + 1)

    tipo = row['Tipo']
    opcoes_str = row['Opções'] || ''

    if tipo == 'Texto' || opcoes_str.blank?
      elemento.campos.build(tipo_elemento: 'Texto', ordem: 1)
    else
      opcoes = opcoes_str.split(',').map(&:strip)
      opcoes.each_with_index do |opcao, opt_idx|
        elemento.campos.build(tipo_elemento: tipo, enunciado: opcao, ordem: opt_idx + 1)
      end
    end
  end

  @template.save!
end

Dado('que existem as seguintes turmas no semestre {string}:') do |semestre, table|
  depto = Departamento.find_or_create_by!(nome: 'Departamento', codigo: 'TST')

  table.hashes.each do |row|
    disciplina = Disciplina.find_or_create_by!(codigo: row['Código']) do |d|
      d.nome = row['Disciplina']
      d.departamento = depto
    end

    Turma.find_or_create_by!(
      disciplina: disciplina,
      numero_da_turma: row['Turma'],
      semestre: semestre
    ) do |t|
      t.horario = 'Seg 08:00-10:00'
    end
  end

  @turmas_disponiveis = Turma.where(semestre: semestre)
end

Quando('eu acesso a página de criação de formulário a partir de template') do
  visit admin_enviar_formularios_path(@admin)
end

Quando('eu seleciono o template {string}') do |nome_template|
  select nome_template, from: 'template_id'
end

Quando('eu não seleciono nenhum template') do
  # Garante que o campo de template permanece em branco
  select 'Template', from: 'template_id'
end

Quando('eu seleciono as turmas {string}') do |turma_info|
  partes = turma_info.split(' - ')
  codigo = partes[0]
  nome_disciplina = partes[1]
  numero_turma = partes[2]

  disciplina = Disciplina.find_by!(codigo: codigo, nome: nome_disciplina)
  turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  check "turma_ids_#{turma.id}"
end

Quando('eu seleciono as turmas {string} e {string}') do |turma1_info, turma2_info|
  [ turma1_info, turma2_info ].each do |turma_info|
    partes = turma_info.split(' - ')
    codigo = partes[0]
    nome_disciplina = partes[1]
    numero_turma = partes[2]

    disciplina = Disciplina.find_by!(codigo: codigo, nome: nome_disciplina)
    turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
    check "turma_ids_#{turma.id}"
  end
end

Quando('eu clico em {string}') do |botao|
  click_button botao
end

Quando('eu não seleciono nenhuma turma') do
  # Nenhum checkbox marcado — ação implícita
end

Então('o formulário deve conter as perguntas do template {string}') do |nome_template|
  template = Template.find_by!(nome: nome_template)
  formulario = Formulario.last
  expect(formulario.elemento_forms.count).to eq(template.elementos.count)
  formulario.elemento_forms.order(:ordem).each_with_index do |ef, i|
    expect(ef.enunciado).to eq(template.elementos.order(:ordem)[i].enunciado)
  end
end

Então('o formulário deve estar associado à turma {string}') do |nome_turma_info|
  partes = nome_turma_info.split(' - ')
  nome_disciplina = partes[0]
  numero_turma = partes[1]

  disciplina = Disciplina.find_by!(nome: nome_disciplina)
  turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  expect(Formulario.last.turma).to eq(turma)
end

Então('deve existir um formulário para a turma {string}') do |nome_turma_info|
  partes = nome_turma_info.split(' - ')
  nome_disciplina = partes[0]
  numero_turma = partes[1]

  disciplina = Disciplina.find_by!(nome: nome_disciplina)
  turma = Turma.find_by!(disciplina: disciplina, numero_da_turma: numero_turma)
  expect(Formulario.exists?(turma: turma)).to be true
end

Então('cada formulário deve conter as perguntas do template {string}') do |nome_template|
  template = Template.find_by!(nome: nome_template)
  Formulario.all.each do |formulario|
    expect(formulario.elemento_forms.count).to eq(template.elementos.count)
  end
end

Então('eu devo ver a lista de templates disponíveis') do
  Template.all.each do |template|
    expect(page).to have_content(template.nome)
  end
end

Então('eu devo ver a lista de turmas do semestre {string} disponíveis') do |semestre|
  Turma.where(semestre: semestre).each do |turma|
    expect(page).to have_content(turma.disciplina.nome)
  end
end
